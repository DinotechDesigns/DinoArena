import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/brand.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/domain/sport_type.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/presentation/providers/booking_providers.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../tournaments/domain/entities/tournament.dart';
import '../../../tournaments/presentation/providers/tournament_providers.dart';
import '../../data/payment_repository_impl.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => AppConfig.useMockData ? DemoPaymentRepository() : RemotePaymentRepository(ref.watch(dioProvider)),
);

/// Anything payable: a slot booking, an event spot or a tournament entry.
class CheckoutRequest {
  const CheckoutRequest({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.venue,
    required this.sport,
    required this.start,
    required this.end,
    required this.lineItems,
    required this.total,
    this.players = 1,
    this.unitLabel,
    this.referenceId,
    this.slotIds = const [],
    this.slotLabels = const [],
    this.registration,
  });

  final BookingKind kind;
  final String title;
  final String subtitle;
  final String venue;
  final SportType sport;
  final DateTime start;
  final DateTime end;
  final List<LineItem> lineItems;
  final int total;
  final int players;
  final String? unitLabel;
  final String? referenceId;
  final List<String> slotIds;
  final List<String> slotLabels;
  final TournamentRegistration? registration;

  NewBooking toNewBooking(BookingStatus status, String? paymentId) => NewBooking(
    kind: kind,
    title: title,
    venue: venue,
    sport: sport,
    start: start,
    end: end,
    amountPaid: total,
    status: status,
    referenceId: referenceId,
    unitLabel: unitLabel,
    paymentId: paymentId,
    slotIds: slotIds,
    slotLabels: slotLabels,
    players: players,
  );
}

class CheckoutState {
  const CheckoutState({
    this.request,
    this.method = PaymentMethod.upi,
    this.demoOutcome = DemoOutcome.success,
    this.processing = false,
    this.result,
    this.booking,
    this.error,
  });

  final CheckoutRequest? request;
  final PaymentMethod method;
  final DemoOutcome demoOutcome;
  final bool processing;
  final PaymentResult? result;
  final Booking? booking;
  final String? error;

  CheckoutState copyWith({
    CheckoutRequest? request,
    PaymentMethod? method,
    DemoOutcome? demoOutcome,
    bool? processing,
    PaymentResult? result,
    Booking? booking,
    String? Function()? error,
  }) => CheckoutState(
    request: request ?? this.request,
    method: method ?? this.method,
    demoOutcome: demoOutcome ?? this.demoOutcome,
    processing: processing ?? this.processing,
    result: result ?? this.result,
    booking: booking ?? this.booking,
    error: error != null ? error() : this.error,
  );
}

final checkoutControllerProvider = NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);

class CheckoutController extends Notifier<CheckoutState> {
  PaymentRepository get _payments => ref.read(paymentRepositoryProvider);

  @override
  CheckoutState build() => const CheckoutState();

  void begin(CheckoutRequest request) => state = CheckoutState(request: request, method: state.method);

  void selectMethod(PaymentMethod method) => state = state.copyWith(method: method);

  void setDemoOutcome(DemoOutcome outcome) => state = state.copyWith(demoOutcome: outcome);

  /// Runs the payment and, on success/pending, issues the booking pass.
  Future<PaymentStatus> pay() async {
    final request = state.request;
    if (request == null || state.processing) return PaymentStatus.failed;
    state = CheckoutState(request: request, method: state.method, demoOutcome: state.demoOutcome, processing: true);
    try {
      final order = await _payments.createOrder(amount: request.total, description: '${Brand.name} · ${request.title}');
      final result = await _payments.pay(order, state.method, demoOutcome: state.demoOutcome);

      Booking? booking;
      if (result.status != PaymentStatus.failed) {
        if (request.registration != null) {
          await ref.read(tournamentRepositoryProvider).register(request.registration!);
          ref.invalidate(tournamentsProvider);
        }
        final status = result.status == PaymentStatus.success ? BookingStatus.confirmed : BookingStatus.pending;
        booking = await ref
            .read(bookingsControllerProvider.notifier)
            .create(request.toNewBooking(status, result.paymentId));
        _notify(booking, result);
      }
      state = state.copyWith(processing: false, result: result, booking: booking, error: () => null);
      return result.status;
    } catch (e) {
      state = state.copyWith(
        processing: false,
        result: PaymentResult(
          orderId: '-',
          status: PaymentStatus.failed,
          amount: request.total,
          method: state.method,
          failureReason: e.toString(),
        ),
        error: () => e.toString(),
      );
      return PaymentStatus.failed;
    }
  }

  /// Re-checks a pending payment and confirms the pass when it clears.
  Future<PaymentStatus> refreshPending() async {
    final pending = state.result;
    if (pending == null || pending.status != PaymentStatus.pending) return pending?.status ?? PaymentStatus.failed;
    state = state.copyWith(processing: true);
    final result = await _payments.checkStatus(pending);
    Booking? booking = state.booking;
    if (result.status == PaymentStatus.success && booking != null) {
      booking = await ref.read(bookingsControllerProvider.notifier).setStatus(booking.id, BookingStatus.confirmed);
      _notify(booking, result);
    }
    state = state.copyWith(processing: false, result: result, booking: booking);
    return result.status;
  }

  void _notify(Booking booking, PaymentResult result) {
    final notifications = ref.read(notificationsControllerProvider.notifier);
    if (result.status == PaymentStatus.pending) {
      notifications.push(
        title: 'Payment processing',
        body: 'We’re confirming ${Fmt.money(result.amount)} for ${booking.title}. Your pass activates once it clears.',
        type: NotificationType.payment,
      );
      return;
    }
    notifications.push(
      title: switch (booking.kind) {
        BookingKind.slot => 'Booking confirmed 🎉',
        BookingKind.event => 'You’re in!',
        BookingKind.tournament => 'Team registered 🏆',
      },
      body:
          '${booking.title} · ${Fmt.date(booking.start)}, ${Fmt.time(booking.start)}. '
          'Your ${Brand.name} pass ${booking.code} is ready.',
      type: booking.kind == BookingKind.tournament ? NotificationType.tournament : NotificationType.booking,
      deepLink: '/pass/${booking.id}',
    );
  }

  void reset() => state = const CheckoutState();
}

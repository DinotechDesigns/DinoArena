import 'package:dinoarena/core/storage/preferences.dart';
import 'package:dinoarena/features/booking/domain/entities/booking.dart';
import 'package:dinoarena/features/booking/presentation/providers/booking_providers.dart';
import 'package:dinoarena/features/notifications/presentation/providers/notification_providers.dart';
import 'package:dinoarena/features/payment/domain/entities/payment.dart';
import 'package:dinoarena/features/payment/domain/repositories/payment_repository.dart';
import 'package:dinoarena/features/payment/presentation/providers/checkout_providers.dart';
import 'package:dinoarena/shared/domain/sport_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final c = ProviderContainer(overrides: [appPreferencesProvider.overrideWithValue(AppPreferences(prefs))]);
  addTearDown(c.dispose);
  await c.read(bookingsControllerProvider.future);
  await c.read(notificationsControllerProvider.future);
  return c;
}

CheckoutRequest _request() {
  final start = DateTime.now().add(const Duration(days: 2));
  return CheckoutRequest(
    kind: BookingKind.event,
    title: 'Super Sunday 6-a-side',
    subtitle: 'test',
    venue: 'The Dino Box',
    sport: SportType.football,
    start: start,
    end: start.add(const Duration(hours: 3)),
    lineItems: const [LineItem(label: 'Entry', amount: 249)],
    total: 249,
  );
}

void main() {
  test('successful payment issues a confirmed pass and a notification', () async {
    final c = await _container();
    final before = c.read(bookingsControllerProvider).value!.length;
    final unreadBefore = c.read(unreadCountProvider);

    c.read(checkoutControllerProvider.notifier)
      ..begin(_request())
      ..selectMethod(PaymentMethod.card);
    final status = await c.read(checkoutControllerProvider.notifier).pay();

    expect(status, PaymentStatus.success);
    final state = c.read(checkoutControllerProvider);
    expect(state.result!.method, PaymentMethod.card);
    expect(state.booking!.status, BookingStatus.confirmed);
    expect(state.booking!.amountPaid, 249);
    expect(c.read(bookingsControllerProvider).value, hasLength(before + 1));
    expect(c.read(unreadCountProvider), unreadBefore + 1);
    expect(c.read(notificationsControllerProvider).value!.first.body, contains('DinoArena pass'));
  });

  test('failed payment creates no booking', () async {
    final c = await _container();
    final before = c.read(bookingsControllerProvider).value!.length;

    c.read(checkoutControllerProvider.notifier)
      ..begin(_request())
      ..setDemoOutcome(DemoOutcome.failure);
    final status = await c.read(checkoutControllerProvider.notifier).pay();

    expect(status, PaymentStatus.failed);
    expect(c.read(checkoutControllerProvider).booking, isNull);
    expect(c.read(checkoutControllerProvider).result!.failureReason, isNotEmpty);
    expect(c.read(bookingsControllerProvider).value, hasLength(before));
  });

  test('pending payment reserves the pass and confirms once it clears', () async {
    final c = await _container();
    c.read(checkoutControllerProvider.notifier)
      ..begin(_request())
      ..setDemoOutcome(DemoOutcome.pending);

    expect(await c.read(checkoutControllerProvider.notifier).pay(), PaymentStatus.pending);
    final pendingBooking = c.read(checkoutControllerProvider).booking!;
    expect(pendingBooking.status, BookingStatus.pending);

    expect(await c.read(checkoutControllerProvider.notifier).refreshPending(), PaymentStatus.success);
    expect(c.read(bookingByIdProvider(pendingBooking.id))!.status, BookingStatus.confirmed);
  });
}

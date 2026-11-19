import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/domain/sport_type.dart';
import '../../../facilities/domain/entities/facility.dart';
import '../../data/booking_repository_impl.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/slot.dart';
import '../../domain/pricing.dart';
import '../../domain/repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => AppConfig.useMockData ? MockBookingRepository() : RemoteBookingRepository(ref.watch(dioProvider)),
);

typedef SlotQuery = ({Facility facility, DateTime date, int unit});

final slotsProvider = StreamProvider.autoDispose.family<List<Slot>, SlotQuery>(
  (ref, q) => ref.watch(bookingRepositoryProvider).watchSlots(facility: q.facility, date: q.date, unit: q.unit),
);

// ---------------------------------------------------------------------------
// My bookings
// ---------------------------------------------------------------------------

final bookingsControllerProvider = AsyncNotifierProvider<BookingsController, List<Booking>>(BookingsController.new);

class BookingsController extends AsyncNotifier<List<Booking>> {
  BookingRepository get _repo => ref.read(bookingRepositoryProvider);

  @override
  Future<List<Booking>> build() => ref.watch(bookingRepositoryProvider).getBookings();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_repo.getBookings);
  }

  Future<Booking> create(NewBooking booking) async {
    final created = await _repo.createBooking(booking);
    state = AsyncData([created, ...?state.value]);
    return created;
  }

  Future<Booking> setStatus(String id, BookingStatus status) async {
    final updated = await _repo.updateStatus(id, status);
    _replace(updated);
    return updated;
  }

  Future<Booking> cancel(String id) async {
    final updated = await _repo.cancelBooking(id);
    _replace(updated);
    return updated;
  }

  void _replace(Booking b) {
    state = AsyncData([for (final x in state.value ?? <Booking>[]) x.id == b.id ? b : x]);
  }
}

final bookingByIdProvider = Provider.family<Booking?, String>(
  (ref, id) => ref.watch(bookingsControllerProvider).value?.where((b) => b.id == id).firstOrNull,
);

final nextBookingProvider = Provider<Booking?>((ref) {
  final upcoming =
      (ref.watch(bookingsControllerProvider).value ?? const <Booking>[]).where((b) => b.isUpcoming).toList()
        ..sort((a, b) => a.start.compareTo(b.start));
  return upcoming.firstOrNull;
});

// ---------------------------------------------------------------------------
// Booking draft (slot selection → summary)
// ---------------------------------------------------------------------------

class BookingDraft {
  const BookingDraft({
    this.facility,
    required this.date,
    this.unit = 0,
    this.sport,
    this.selected = const [],
    this.coupon,
    this.players = 2,
  });

  final Facility? facility;
  final DateTime date;
  final int unit;
  final SportType? sport;
  final List<Slot> selected;
  final String? coupon;
  final int players;

  List<Slot> get sortedSlots => [...selected]..sort((a, b) => a.start.compareTo(b.start));
  int get subtotal => selected.fold(0, (sum, s) => sum + s.price);
  PriceBreakdown get price => PriceBreakdown.calculate(subtotal, coupon: coupon);
  bool get hasSelection => selected.isNotEmpty;
  int get hours => selected.length;

  List<String> get slotLabels => [for (final s in sortedSlots) '${Fmt.hour(s.start)} – ${Fmt.hour(s.end)}'];

  BookingDraft copyWith({
    Facility? facility,
    DateTime? date,
    int? unit,
    SportType? sport,
    List<Slot>? selected,
    String? Function()? coupon,
    int? players,
  }) => BookingDraft(
    facility: facility ?? this.facility,
    date: date ?? this.date,
    unit: unit ?? this.unit,
    sport: sport ?? this.sport,
    selected: selected ?? this.selected,
    coupon: coupon != null ? coupon() : this.coupon,
    players: players ?? this.players,
  );
}

final bookingDraftProvider = NotifierProvider<BookingDraftController, BookingDraft>(BookingDraftController.new);

class BookingDraftController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() => BookingDraft(date: DateTime.now().dateOnly);

  void start(Facility facility, {DateTime? date}) {
    if (state.facility?.id == facility.id && date == null) return;
    state = BookingDraft(
      facility: facility,
      date: (date ?? DateTime.now()).dateOnly,
      sport: facility.primarySport,
      players: (facility.maxPlayers / 2).ceil().clamp(1, facility.maxPlayers),
    );
  }

  void setDate(DateTime date) => state = state.copyWith(date: date.dateOnly, selected: const []);

  void setUnit(int unit) => state = state.copyWith(unit: unit, selected: const []);

  void setSport(SportType sport) => state = state.copyWith(sport: sport);

  void setPlayers(int players) {
    final max = state.facility?.maxPlayers ?? 20;
    state = state.copyWith(players: players.clamp(1, max));
  }

  void toggle(Slot slot) {
    if (!slot.isAvailable) return;
    final exists = state.selected.any((s) => s.id == slot.id);
    state = state.copyWith(
      selected: exists ? state.selected.where((s) => s.id != slot.id).toList() : [...state.selected, slot],
    );
  }

  /// Drops selections that someone else just took. Returns how many were removed.
  int reconcile(List<Slot> live) {
    final byId = {for (final s in live) s.id: s};
    final keep = state.selected.where((s) => byId[s.id]?.isAvailable ?? false).toList();
    final removed = state.selected.length - keep.length;
    if (removed > 0) state = state.copyWith(selected: keep);
    return removed;
  }

  bool applyCoupon(String code) {
    final valid = PriceBreakdown.coupons.containsKey(code.trim().toUpperCase());
    if (valid) state = state.copyWith(coupon: () => code.trim().toUpperCase());
    return valid;
  }

  void removeCoupon() => state = state.copyWith(coupon: () => null);

  void clear() => state = BookingDraft(date: DateTime.now().dateOnly);
}

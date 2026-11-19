import 'package:dinoarena/core/utils/formatters.dart';
import 'package:dinoarena/features/booking/data/booking_repository_impl.dart';
import 'package:dinoarena/features/booking/domain/entities/booking.dart';
import 'package:dinoarena/features/booking/domain/entities/slot.dart';
import 'package:dinoarena/features/booking/domain/repositories/booking_repository.dart';
import 'package:dinoarena/shared/data/mock_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final nets = MockCatalog.facilities.firstWhere((f) => f.id == 'practice-nets');
  final tomorrow = DateTime.now().dateOnly.add(const Duration(days: 1));

  test('generates hourly slots across opening hours with peak pricing', () async {
    final repo = MockBookingRepository();
    final slots = await repo.watchSlots(facility: nets, date: tomorrow, unit: 0).first;

    expect(slots, hasLength(nets.closeHour - nets.openHour));
    expect(slots.first.start.hour, nets.openHour);
    for (final s in slots) {
      expect(s.end.difference(s.start), const Duration(hours: 1));
      expect(s.price, nets.priceFor(s.start));
      expect(s.status, isNot(SlotStatus.blocked), reason: 'future slots are never blocked');
    }
  });

  test('slots already started today are blocked', () async {
    final repo = MockBookingRepository();
    final today = await repo.watchSlots(facility: nets, date: DateTime.now(), unit: 0).first;
    final now = DateTime.now();
    for (final s in today.where((s) => !s.start.isAfter(now))) {
      expect(s.status, SlotStatus.blocked);
    }
  });

  test('a confirmed booking takes its slot and can be cancelled', () async {
    final repo = MockBookingRepository();
    final slots = await repo.watchSlots(facility: nets, date: tomorrow, unit: 1).first;
    final open = slots.firstWhere((s) => s.isAvailable);

    final booking = await repo.createBooking(
      NewBooking(
        kind: BookingKind.slot,
        title: 'Cricket Nets · ${nets.name}',
        venue: nets.name,
        sport: nets.primarySport,
        start: open.start,
        end: open.end,
        amountPaid: 826,
        status: BookingStatus.confirmed,
        referenceId: nets.id,
        unitLabel: unitName(nets, 1),
        slotIds: [open.id],
      ),
    );
    expect(booking.code, startsWith('DINO-'));
    expect(booking.unitLabel, 'Lane B');

    final after = await repo.watchSlots(facility: nets, date: tomorrow, unit: 1).first;
    expect(after.firstWhere((s) => s.id == open.id).status, SlotStatus.booked);

    // Lane A is independent.
    final laneA = await repo.watchSlots(facility: nets, date: tomorrow, unit: 0).first;
    expect(laneA.firstWhere((s) => s.start == open.start).id, isNot(open.id));

    final cancelled = await repo.cancelBooking(booking.id);
    expect(cancelled.status, BookingStatus.cancelled);
  });

  test('double-booking the same slot is rejected', () async {
    final repo = MockBookingRepository();
    final open = (await repo.watchSlots(facility: nets, date: tomorrow, unit: 0).first).firstWhere((s) => s.isAvailable);
    NewBooking req() => NewBooking(
      kind: BookingKind.slot,
      title: 'x',
      venue: 'x',
      sport: nets.primarySport,
      start: open.start,
      end: open.end,
      amountPaid: 1,
      status: BookingStatus.confirmed,
      slotIds: [open.id],
    );
    await repo.createBooking(req());
    expect(repo.createBooking(req()), throwsA(isA<Exception>()));
  });
}

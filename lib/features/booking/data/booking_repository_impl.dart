import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/brand.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/data/mock_catalog.dart';
import '../../facilities/domain/entities/facility.dart';
import '../domain/entities/booking.dart';
import '../domain/entities/slot.dart';
import '../domain/repositories/booking_repository.dart';

String unitName(Facility f, int unit) =>
    f.hasMultipleUnits ? '${f.unitLabel} ${String.fromCharCode(65 + unit)}' : f.unitLabel;

class MockBookingRepository implements BookingRepository {
  MockBookingRepository() : _bookings = MockCatalog.seedBookings();

  final List<Booking> _bookings;
  final Set<String> _bookedSlotIds = {};
  final Random _random = Random();

  static String slotId(String facilityId, int unit, DateTime start) =>
      '${facilityId}_u${unit}_${DateFormat('yyyyMMddHH').format(start)}';

  int _stableHash(String facilityId, DateTime date, int hour, int unit) {
    var h = 17;
    for (final c in facilityId.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    h = (h ^ ((date.year * 10000 + date.month * 100 + date.day) * 2654435761)) & 0x7fffffff;
    h = (h ^ (hour * 40503) ^ (unit * 9973)) & 0x7fffffff;
    h = (h * 1103515245 + 12345) & 0x7fffffff;
    return h % 100;
  }

  bool _overlapsUserBooking(Facility f, String unitLabel, DateTime start) => _bookings.any(
    (b) =>
        b.kind == BookingKind.slot &&
        b.referenceId == f.id &&
        b.unitLabel == unitLabel &&
        (b.status == BookingStatus.confirmed || b.status == BookingStatus.pending) &&
        !start.isBefore(b.start) &&
        start.isBefore(b.end),
  );

  List<Slot> _generate(Facility f, DateTime date, int unit) {
    final day = date.dateOnly;
    final now = DateTime.now();
    final label = unitName(f, unit);
    return [
      for (var hour = f.openHour; hour < f.closeHour; hour++)
        () {
          final start = day.add(Duration(hours: hour));
          final id = slotId(f.id, unit, start);
          final peak = f.isPeak(start);
          final SlotStatus status;
          if (!start.isAfter(now)) {
            status = SlotStatus.blocked;
          } else if (_bookedSlotIds.contains(id) || _overlapsUserBooking(f, label, start)) {
            status = SlotStatus.booked;
          } else {
            status = _stableHash(f.id, day, hour, unit) < (peak ? 42 : 18) ? SlotStatus.booked : SlotStatus.available;
          }
          return Slot(
            id: id,
            facilityId: f.id,
            unit: unit,
            start: start,
            end: start.add(const Duration(hours: 1)),
            price: f.priceFor(start),
            status: status,
            isPeak: peak,
          );
        }(),
    ];
  }

  /// Simulates other players: an open slot gets held, a held slot gets booked or released.
  List<Slot> _tick(List<Slot> slots) {
    final next = [...slots];
    for (var i = 0; i < next.length; i++) {
      if (next[i].status == SlotStatus.held) {
        final taken = _random.nextBool();
        next[i] = next[i].copyWith(status: taken ? SlotStatus.booked : SlotStatus.available);
        if (taken) _bookedSlotIds.add(next[i].id);
      }
    }
    final open = [
      for (var i = 0; i < next.length; i++)
        if (next[i].isAvailable) i,
    ];
    if (open.isNotEmpty) {
      final i = open[_random.nextInt(open.length)];
      next[i] = next[i].copyWith(status: SlotStatus.held);
    }
    return next;
  }

  @override
  Stream<List<Slot>> watchSlots({required Facility facility, required DateTime date, required int unit}) async* {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    var slots = _generate(facility, date, unit);
    yield slots;
    while (true) {
      await Future<void>.delayed(Duration(seconds: 8 + _random.nextInt(7)));
      // Re-apply local bookings, then simulate the crowd.
      final fresh = {for (final s in _generate(facility, date, unit)) s.id: s};
      slots = _tick([
        for (final s in slots)
          s.status == SlotStatus.held ? s : (fresh[s.id]!.status == SlotStatus.booked ? fresh[s.id]! : s),
      ]);
      yield slots;
    }
  }

  @override
  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_bookings..sort((a, b) => b.start.compareTo(a.start)));
  }

  String _newCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return '${Brand.passPrefix}-${List.generate(6, (_) => chars[_random.nextInt(chars.length)]).join()}';
  }

  @override
  Future<Booking> createBooking(NewBooking b) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (b.slotIds.any(_bookedSlotIds.contains)) {
      throw const ApiException('One of your slots was just booked by someone else. Please pick another.');
    }
    final booking = Booking(
      id: 'bk_${DateTime.now().microsecondsSinceEpoch}',
      code: _newCode(),
      kind: b.kind,
      title: b.title,
      venue: b.venue,
      sport: b.sport,
      start: b.start,
      end: b.end,
      amountPaid: b.amountPaid,
      status: b.status,
      createdAt: DateTime.now(),
      referenceId: b.referenceId,
      unitLabel: b.unitLabel,
      paymentId: b.paymentId,
      slotLabels: b.slotLabels,
      players: b.players,
    );
    _bookedSlotIds.addAll(b.slotIds);
    _bookings.add(booking);
    return booking;
  }

  Booking _replace(String id, Booking Function(Booking) update) {
    final i = _bookings.indexWhere((b) => b.id == id);
    if (i < 0) throw const ApiException('Booking not found', statusCode: 404);
    return _bookings[i] = update(_bookings[i]);
  }

  @override
  Future<Booking> updateStatus(String bookingId, BookingStatus status) async =>
      _replace(bookingId, (b) => b.copyWith(status: status));

  @override
  Future<Booking> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _replace(bookingId, (b) => b.copyWith(status: BookingStatus.cancelled));
  }
}

class RemoteBookingRepository implements BookingRepository {
  RemoteBookingRepository(this._dio);

  final Dio _dio;

  Future<List<Slot>> _fetchSlots(Facility f, DateTime date, int unit) => guardApi(() async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.slots(f.id),
      queryParameters: {'date': DateFormat('yyyy-MM-dd').format(date), 'unit': unit},
    );
    return res.data!.map((e) => Slot.fromJson(e as Map<String, dynamic>)).toList();
  });

  @override
  Stream<List<Slot>> watchSlots({required Facility facility, required DateTime date, required int unit}) async* {
    yield await _fetchSlots(facility, date, unit);
    yield* Stream.periodic(AppConfig.slotPollInterval).asyncMap((_) => _fetchSlots(facility, date, unit));
  }

  @override
  Future<List<Booking>> getBookings() => guardApi(() async {
    final res = await _dio.get<List<dynamic>>(ApiEndpoints.bookings);
    return res.data!.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
  });

  @override
  Future<Booking> createBooking(NewBooking b) => guardApi(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.bookings,
      data: {
        'kind': b.kind.name,
        'reference_id': b.referenceId,
        'slot_ids': b.slotIds,
        'payment_id': b.paymentId,
        'players': b.players,
      },
    );
    return Booking.fromJson(res.data!);
  });

  @override
  Future<Booking> updateStatus(String bookingId, BookingStatus status) => guardApi(() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.booking(bookingId));
    return Booking.fromJson(res.data!);
  });

  @override
  Future<Booking> cancelBooking(String bookingId) => guardApi(() async {
    final res = await _dio.post<Map<String, dynamic>>(ApiEndpoints.cancelBooking(bookingId));
    return Booking.fromJson(res.data!);
  });
}

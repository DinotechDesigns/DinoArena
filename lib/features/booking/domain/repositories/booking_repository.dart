import '../../../../shared/domain/sport_type.dart';
import '../../../facilities/domain/entities/facility.dart';
import '../entities/booking.dart';
import '../entities/slot.dart';

/// Everything needed to issue a booking / entry pass after payment.
class NewBooking {
  const NewBooking({
    required this.kind,
    required this.title,
    required this.venue,
    required this.sport,
    required this.start,
    required this.end,
    required this.amountPaid,
    required this.status,
    this.referenceId,
    this.unitLabel,
    this.paymentId,
    this.slotIds = const [],
    this.slotLabels = const [],
    this.players = 1,
  });

  final BookingKind kind;
  final String title;
  final String venue;
  final SportType sport;
  final DateTime start;
  final DateTime end;
  final int amountPaid;
  final BookingStatus status;
  final String? referenceId;
  final String? unitLabel;
  final String? paymentId;
  final List<String> slotIds;
  final List<String> slotLabels;
  final int players;
}

abstract interface class BookingRepository {
  /// Live availability for one facility unit on one day.
  ///
  /// Mock mode simulates other players booking; remote mode polls the API
  /// (swap for a websocket channel when the backend exposes one).
  Stream<List<Slot>> watchSlots({required Facility facility, required DateTime date, required int unit});

  Future<List<Booking>> getBookings();

  Future<Booking> createBooking(NewBooking booking);

  Future<Booking> updateStatus(String bookingId, BookingStatus status);

  Future<Booking> cancelBooking(String bookingId);
}

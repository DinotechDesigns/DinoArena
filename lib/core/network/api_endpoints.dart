/// REST paths for the FastAPI backend. Kept in one place so the contract is easy to audit.
abstract final class ApiEndpoints {
  // Auth
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  static const String me = '/users/me';

  // Facilities & slots
  static const String facilities = '/facilities';
  static String facility(String id) => '/facilities/$id';
  static String slots(String facilityId) => '/facilities/$facilityId/slots';

  // Bookings
  static const String bookings = '/bookings';
  static String booking(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';

  // Payments
  static const String createPaymentOrder = '/payments/orders';
  static String paymentStatus(String orderId) => '/payments/orders/$orderId';

  // Events & tournaments
  static const String events = '/events';
  static const String tournaments = '/tournaments';
  static String tournamentRegister(String id) => '/tournaments/$id/registrations';

  // Notifications & support
  static const String notifications = '/notifications';
  static const String markNotificationsRead = '/notifications/read';
  static const String supportTickets = '/support/tickets';
}

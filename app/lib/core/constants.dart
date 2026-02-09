class ApiConstants {
  static const String baseUrl = 'https://orestislef.gr/swim/api';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String authStatus = '/auth/status';

  // Data
  static const String dashboard = '/dashboard';
  static const String bookings = '/bookings';
  static const String courses = '/courses';
  static const String subscriptions = '/subscriptions';
  static const String attendances = '/attendances';
  static const String waitlist = '/waitlist';
  static const String cancellations = '/cancellations';
  static const String barcode = '/barcode';
  static const String users = '/users';

  // Booking actions
  static const String bookingSlots = '/booking/slots';
  static const String bookingBook = '/booking/book';
  static const String bookingCancel = '/booking/cancel';
}

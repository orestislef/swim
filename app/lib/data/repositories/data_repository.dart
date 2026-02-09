import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants.dart';
import '../api_client.dart';
import '../models/attendance.dart';
import '../models/barcode_data.dart';
import '../models/booking.dart';
import '../models/subscription.dart';
import '../models/time_slot.dart';
import '../models/user.dart';
import '../models/waitlist_item.dart';

class DataRepository {
  final ApiClient _client;

  DataRepository(this._client);

  Future<User?> getDashboard() async {
    try {
      final response = await _client.dio.get(ApiConstants.dashboard);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return User.fromJson(data['data'] as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      debugPrint('getDashboard error: ${e.message} status=${e.response?.statusCode} data=${e.response?.data}');
      rethrow;
    }
    return null;
  }

  Future<List<Booking>> getBookings() async {
    try {
      final response = await _client.dio.get(ApiConstants.bookings);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final bookingsData = data['data'] as Map<String, dynamic>;
        final list = bookingsData['bookings'] as List<dynamic>? ?? [];
        return list
            .map((e) => Booking.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint('getBookings error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<List<String>> getCourseTypes() async {
    try {
      final response = await _client.dio.get(ApiConstants.courses);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final coursesData = data['data'] as Map<String, dynamic>;
        final types = coursesData['courseTypes'] as List<dynamic>? ?? [];
        return types.map((e) => e.toString()).toList();
      }
    } on DioException catch (e) {
      debugPrint('getCourseTypes error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<List<TimeSlot>> getSlots(String date, String courseType) async {
    try {
      final response = await _client.dio.get(
        ApiConstants.bookingSlots,
        queryParameters: {'date': date, 'courseType': courseType},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        final slots = data['slots'] as List<dynamic>? ?? [];
        return slots
            .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint('getSlots error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<({bool success, String? error})> bookClass(
      String date, String courseType, String slotId) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.bookingBook,
        data: {'date': date, 'courseType': courseType, 'slotId': slotId},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return (success: true, error: null);
      }
      return (
        success: false,
        error: data['error'] as String? ?? 'Booking failed'
      );
    } on DioException catch (e) {
      return (success: false, error: e.message ?? 'Connection error');
    }
  }

  Future<({bool success, String? error})> cancelBooking(
      String bookingId) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.bookingCancel,
        data: {'bookingId': bookingId},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return (success: true, error: null);
      }
      return (
        success: false,
        error: data['error'] as String? ?? 'Cancel failed'
      );
    } on DioException catch (e) {
      return (success: false, error: e.message ?? 'Connection error');
    }
  }

  Future<List<Subscription>> getSubscriptions() async {
    try {
      final response = await _client.dio.get(ApiConstants.subscriptions);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint('getSubscriptions error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<List<Attendance>> getAttendances() async {
    try {
      final response = await _client.dio.get(ApiConstants.attendances);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => Attendance.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint('getAttendances error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<List<WaitlistItem>> getWaitlist() async {
    try {
      final response = await _client.dio.get(ApiConstants.waitlist);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => WaitlistItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint('getWaitlist error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<List<WaitlistItem>> getCancellations() async {
    try {
      final response = await _client.dio.get(ApiConstants.cancellations);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        final list = data['data'] as List<dynamic>;
        return list
            .map((e) => WaitlistItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on DioException catch (e) {
      debugPrint('getCancellations error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return [];
  }

  Future<BarcodeData?> getBarcode() async {
    try {
      final response = await _client.dio.get(ApiConstants.barcode);
      debugPrint('getBarcode raw response: ${response.data}');
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final barcodeData = data['data'] as Map<String, dynamic>;
          debugPrint('getBarcode parsed: code="${barcodeData['code']}" svg_len=${(barcodeData['svg'] as String?)?.length ?? 0}');
          return BarcodeData.fromJson(barcodeData);
        }
        debugPrint('getBarcode: success=${data['success']} error=${data['error']}');
      }
    } on DioException catch (e) {
      debugPrint('getBarcode error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return null;
  }

  Future<User?> getProfile() async {
    try {
      final response = await _client.dio.get(ApiConstants.users);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return User.fromJson(data['data'] as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      debugPrint('getProfile error: ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
    return null;
  }
}

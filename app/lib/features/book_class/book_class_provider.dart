import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/time_slot.dart';
import '../../data/repositories/data_repository.dart';
import '../dashboard/dashboard_provider.dart';

class BookClassState {
  final List<String> courseTypes;
  final String? selectedCourse;
  final DateTime? selectedDate;
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final int currentStep; // 0=course, 1=date, 2=time, 3=confirm
  final bool isLoading;
  final String? error;
  final bool bookingSuccess;

  const BookClassState({
    this.courseTypes = const [],
    this.selectedCourse,
    this.selectedDate,
    this.slots = const [],
    this.selectedSlot,
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
    this.bookingSuccess = false,
  });

  BookClassState copyWith({
    List<String>? courseTypes,
    String? selectedCourse,
    DateTime? selectedDate,
    List<TimeSlot>? slots,
    TimeSlot? selectedSlot,
    int? currentStep,
    bool? isLoading,
    String? error,
    bool? bookingSuccess,
    bool clearDate = false,
    bool clearSlot = false,
    bool clearCourse = false,
  }) {
    return BookClassState(
      courseTypes: courseTypes ?? this.courseTypes,
      selectedCourse: clearCourse ? null : (selectedCourse ?? this.selectedCourse),
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      slots: slots ?? this.slots,
      selectedSlot: clearSlot ? null : (selectedSlot ?? this.selectedSlot),
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
    );
  }
}

class BookClassNotifier extends StateNotifier<BookClassState> {
  final DataRepository _dataRepo;

  BookClassNotifier(this._dataRepo) : super(const BookClassState());

  Future<void> loadCourses() async {
    state = state.copyWith(isLoading: true);
    final types = await _dataRepo.getCourseTypes();
    state = state.copyWith(courseTypes: types, isLoading: false);
  }

  void selectCourse(String course) {
    state = BookClassState(
      courseTypes: state.courseTypes,
      selectedCourse: course,
      currentStep: 1,
    );
  }

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(
      selectedDate: date,
      currentStep: 2,
      isLoading: true,
      slots: [],
      clearSlot: true,
    );

    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final slots = await _dataRepo.getSlots(dateStr, state.selectedCourse!);
    state = state.copyWith(slots: slots, isLoading: false);
  }

  void selectSlot(TimeSlot slot) {
    state = state.copyWith(selectedSlot: slot, currentStep: 3);
  }

  Future<void> confirmBooking() async {
    if (state.selectedDate == null ||
        state.selectedCourse == null ||
        state.selectedSlot == null) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final date = state.selectedDate!;
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final result = await _dataRepo.bookClass(
      dateStr,
      state.selectedCourse!,
      state.selectedSlot!.id,
    );

    if (result.success) {
      state = state.copyWith(isLoading: false, bookingSuccess: true);
    } else {
      state = state.copyWith(isLoading: false, error: result.error);
    }
  }

  void reset() {
    state = BookClassState(courseTypes: state.courseTypes);
  }
}

final bookClassProvider =
    StateNotifierProvider<BookClassNotifier, BookClassState>((ref) {
  return BookClassNotifier(ref.watch(dataRepositoryProvider));
});

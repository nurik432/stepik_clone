// frontend/lib/features/student_dashboard/presentation/providers/student_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/courses/domain/models/course.dart';
import 'package:stepik_clone/features/student_dashboard/data/student_repository.dart';
import 'package:stepik_clone/features/student_dashboard/domain/models/enrollment.dart';

class StudentState {
  final bool isLoading;
  final String? error;
  final List<Course> allCourses;
  final List<Enrollment> myEnrollments;

  StudentState({
    this.isLoading = false,
    this.error,
    this.allCourses = const [],
    this.myEnrollments = const [],
  });

  StudentState copyWith({
    bool? isLoading,
    String? error,
    List<Course>? allCourses,
    List<Enrollment>? myEnrollments,
  }) {
    return StudentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      allCourses: allCourses ?? this.allCourses,
      myEnrollments: myEnrollments ?? this.myEnrollments,
    );
  }
}

class StudentNotifier extends StateNotifier<StudentState> {
  final StudentRepository _repository;

  StudentNotifier(this._repository) : super(StudentState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final courses = await _repository.getAllPublishedCourses();
      final enrollments = await _repository.getMyEnrollments();
      state = state.copyWith(
        isLoading: false, 
        allCourses: courses, 
        myEnrollments: enrollments
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> enroll(int courseId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final enrollment = await _repository.enrollInCourse(courseId);
      state = state.copyWith(
        isLoading: false,
        myEnrollments: [...state.myEnrollments, enrollment],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> completeLesson(int lessonId) async {
    try {
      await _repository.markLessonCompleted(lessonId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return StudentNotifier(repository);
});

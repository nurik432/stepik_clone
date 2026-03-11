// frontend/lib/features/teacher_panel/presentation/providers/teacher_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/courses/domain/models/course.dart';
import 'package:stepik_clone/features/teacher_panel/data/teacher_repository.dart';

class TeacherState {
  final bool isLoading;
  final String? error;
  final List<Course> courses;
  final Course? selectedCourse;

  TeacherState({
    this.isLoading = false,
    this.error,
    this.courses = const [],
    this.selectedCourse,
  });

  TeacherState copyWith({
    bool? isLoading,
    String? error,
    List<Course>? courses,
    Course? selectedCourse,
  }) {
    return TeacherState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      courses: courses ?? this.courses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
    );
  }
}

class TeacherNotifier extends StateNotifier<TeacherState> {
  final TeacherRepository _repository;

  TeacherNotifier(this._repository) : super(TeacherState()) {
    loadCourses();
  }

  Future<void> loadCourses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final courses = await _repository.getMyCourses();
      state = state.copyWith(isLoading: false, courses: courses);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createCourse(String title, String description) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newCourse = await _repository.createCourse(title, description);
      state = state.copyWith(
        isLoading: false,
        courses: [...state.courses, newCourse],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectCourse(Course? course) {
    state = state.copyWith(selectedCourse: course);
  }

  Future<void> updateCourse(int courseId, Map<String, dynamic> data) async {
    try {
      final updatedCourse = await _repository.updateCourse(courseId, data);
      
      // Обновляем в списке и текущий выбранный
      final updatedList = state.courses.map((c) {
        return c.id == courseId ? updatedCourse : c;
      }).toList();
      
      state = state.copyWith(
        courses: updatedList,
        selectedCourse: state.selectedCourse?.id == courseId ? updatedCourse : state.selectedCourse,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createModule(int courseId, String title, int order) async {
    try {
      await _repository.createModule(courseId, title, order);
      // Чтобы получить обновленный курс с модулями, просто перекачиваем список (упрощение)
      await loadCourses();
      
      // Обновляем выбранный курс
      if (state.selectedCourse != null && state.selectedCourse!.id == courseId) {
        final updatedCourse = state.courses.firstWhere((c) => c.id == courseId);
        state = state.copyWith(selectedCourse: updatedCourse);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final teacherProvider = StateNotifierProvider<TeacherNotifier, TeacherState>((ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return TeacherNotifier(repository);
});

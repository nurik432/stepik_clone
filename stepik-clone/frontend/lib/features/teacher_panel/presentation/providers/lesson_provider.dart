// frontend/lib/features/teacher_panel/presentation/providers/lesson_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/lessons/domain/models/lesson.dart';
import 'package:stepik_clone/features/teacher_panel/data/lesson_repository.dart';

class LessonState {
  final bool isLoading;
  final String? error;
  final Lesson? currentLesson;

  LessonState({
    this.isLoading = false,
    this.error,
    this.currentLesson,
  });

  LessonState copyWith({
    bool? isLoading,
    String? error,
    Lesson? currentLesson,
  }) {
    return LessonState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentLesson: currentLesson ?? this.currentLesson,
    );
  }
}

class LessonNotifier extends StateNotifier<LessonState> {
  final LessonRepository _repository;

  LessonNotifier(this._repository) : super(LessonState());

  Future<void> createLessonAndContent(int moduleId, String title, String type, String content) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newLesson = await _repository.createLesson(moduleId, title, 0, type); // order 0 for test
      
      if (type == 'text') {
        await _repository.createLessonContent(newLesson.id, content);
      } else if (type == 'video') {
         // mock video save with text representing filename
         await _repository.createLessonContent(newLesson.id, "video_mock:$content");
      }
      
      state = state.copyWith(isLoading: false, currentLesson: newLesson);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createQuizLesson(int moduleId, String title, Map<String, dynamic> quizData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newLesson = await _repository.createLesson(moduleId, title, 0, 'quiz');
      await _repository.createQuiz(newLesson.id, quizData);
      
      state = state.copyWith(isLoading: false, currentLesson: newLesson);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  final repository = ref.watch(lessonRepositoryProvider);
  return LessonNotifier(repository);
});

// frontend/lib/features/teacher_panel/data/lesson_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/lessons/domain/models/lesson.dart';
import 'package:stepik_clone/shared/network/api_client.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LessonRepository(dio);
});

class LessonRepository {
  final Dio _dio;

  LessonRepository(this._dio);

  Future<Lesson> createLesson(int moduleId, String title, int order, String type) async {
    try {
      final response = await _dio.post('/lessons/module/$moduleId/lessons', data: {
        'title': title,
        'order': order,
        'type': type,
      });
      return Lesson.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка создания урока");
    }
  }

  Future<LessonContent> createLessonContent(int lessonId, String text) async {
    try {
      final response = await _dio.post('/lessons/$lessonId/content', data: {
        'content_text': text,
      });
      return LessonContent.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка сохранения контента");
    }
  }

  // Оставляем Future<void>, так как для мока S3 будем использовать FormData
  // Будет добавлено позже, если понадобится загружать реальный файл
  
  Future<Quiz> createQuiz(int lessonId, Map<String, dynamic> quizData) async {
    try {
      final response = await _dio.post('/lessons/$lessonId/quiz', data: quizData);
      return Quiz.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка создания квиза");
    }
  }
}

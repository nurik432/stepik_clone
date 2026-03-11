// frontend/lib/features/student_dashboard/data/student_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/courses/domain/models/course.dart';
import 'package:stepik_clone/features/student_dashboard/domain/models/enrollment.dart';
import 'package:stepik_clone/shared/network/api_client.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return StudentRepository(dio);
});

class StudentRepository {
  final Dio _dio;

  StudentRepository(this._dio);

  Future<List<Course>> getAllPublishedCourses() async {
    try {
      final response = await _dio.get('/courses/');
      return (response.data as List).map((e) => Course.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка загрузки курсов");
    }
  }

  Future<List<Enrollment>> getMyEnrollments() async {
    try {
      final response = await _dio.get('/enrollments/my');
      return (response.data as List).map((e) => Enrollment.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка загрузки ваших курсов");
    }
  }

  Future<Enrollment> enrollInCourse(int courseId) async {
    try {
      final response = await _dio.post('/enrollments/$courseId');
      return Enrollment.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка записи на курс");
    }
  }

  Future<void> markLessonCompleted(int lessonId) async {
    try {
      await _dio.post('/progress/lesson/$lessonId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка сохранения прогресса");
    }
  }

  Future<void> submitQuizAttempt(int quizId, double score) async {
    try {
      await _dio.post('/progress/quiz/$quizId', data: {'score': score});
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка отправки теста");
    }
  }
}

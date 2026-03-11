// frontend/lib/features/teacher_panel/data/teacher_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/courses/domain/models/course.dart';
import 'package:stepik_clone/shared/network/api_client.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TeacherRepository(dio);
});

class TeacherRepository {
  final Dio _dio;

  TeacherRepository(this._dio);

  Future<List<Course>> getMyCourses() async {
    try {
      final response = await _dio.get('/courses/teacher');
      return (response.data as List).map((e) => Course.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка загрузки курсов");
    }
  }

  Future<Course> createCourse(String title, String description) async {
    try {
      final response = await _dio.post('/courses/', data: {
        'title': title,
        'description': description,
      });
      return Course.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка создания курса");
    }
  }

  Future<Course> updateCourse(int courseId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/courses/$courseId', data: data);
      return Course.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка обновления курса");
    }
  }

  Future<Module> createModule(int courseId, String title, int order) async {
    try {
      final response = await _dio.post('/courses/$courseId/modules', data: {
        'title': title,
        'order': order,
      });
      return Module.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка создания модуля");
    }
  }
}

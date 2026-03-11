// frontend/lib/features/admin_panel/data/admin_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/shared/network/api_client.dart';
import 'package:stepik_clone/features/auth/domain/models/user.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AdminRepository(dio);
});

class AdminRepository {
  final Dio _dio;

  AdminRepository(this._dio);

  Future<Map<String, dynamic>> getPlatformStats() async {
    try {
      final response = await _dio.get('/admin/stats');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка загрузки статистики");
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('/admin/users');
      return (response.data as List).map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка загрузки пользователей");
    }
  }

  Future<List<Map<String, dynamic>>> getWaitlist() async {
    try {
      final response = await _dio.get('/admin/waitlist');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка загрузки листа ожидания");
    }
  }
}

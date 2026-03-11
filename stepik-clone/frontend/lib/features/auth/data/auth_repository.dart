// frontend/lib/features/auth/data/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/auth/domain/models/user.dart';
import 'package:stepik_clone/shared/network/api_client.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository {
  final Dio _dio;
  
  AuthRepository(this._dio);

  Future<User> register(String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
      });
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception(e.response?.data['detail'] ?? "Лимит пользователей достигнут");
      }
      throw Exception(e.response?.data['detail'] ?? "Ошибка регистрации");
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data['access_token'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? "Ошибка входа");
    }
  }
}

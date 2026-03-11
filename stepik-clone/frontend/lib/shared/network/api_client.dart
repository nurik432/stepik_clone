// frontend/lib/shared/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/shared/network/token_provider.dart';

const String baseUrl = '/api';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Перехватчик для добавления токена авторизации
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      if (e.response?.statusCode == 401) {
        // Если токен недействителен, сбрасываем его
        ref.read(authTokenProvider.notifier).state = null;
      }
      return handler.next(e);
    },
  ));

  return dio;
});

// frontend/lib/shared/network/token_provider.dart
// Хранилище токена, вынесено в отдельный файл для разрыва циклического импорта.
// api_client.dart и auth_provider.dart импортируют это, но не друг друга.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

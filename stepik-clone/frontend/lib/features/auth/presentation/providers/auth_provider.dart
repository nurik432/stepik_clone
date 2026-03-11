// frontend/lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/auth/data/auth_repository.dart';
import 'package:stepik_clone/shared/network/token_provider.dart';

// Состояние аутентификации
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isWaitlisted;
  final String? token;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isWaitlisted = false,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isWaitlisted,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isWaitlisted: isWaitlisted ?? this.isWaitlisted,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _repository.login(email, password);
      _ref.read(authTokenProvider.notifier).state = token;
      state = state.copyWith(isLoading: false, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, isWaitlisted: false);
    try {
      await _repository.register(email, password);
      // После успешной регистрации логинимся
      await login(email, password);
    } catch (e) {
      if (e.toString().contains('ожидания') || e.toString().contains('лимит')) {
        state = state.copyWith(isLoading: false, isWaitlisted: true, error: e.toString());
      } else {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  void logout() {
    _ref.read(authTokenProvider.notifier).state = null;
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository, ref);
});

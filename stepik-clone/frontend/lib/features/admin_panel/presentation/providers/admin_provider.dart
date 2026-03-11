// frontend/lib/features/admin_panel/presentation/providers/admin_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/admin_panel/data/admin_repository.dart';
import 'package:stepik_clone/features/auth/domain/models/user.dart';

class AdminState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? stats;
  final List<User> users;
  final List<Map<String, dynamic>> waitlist;

  AdminState({
    this.isLoading = false,
    this.error,
    this.stats,
    this.users = const [],
    this.waitlist = const [],
  });

  AdminState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? stats,
    List<User>? users,
    List<Map<String, dynamic>>? waitlist,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
      users: users ?? this.users,
      waitlist: waitlist ?? this.waitlist,
    );
  }
}

class AdminNotifier extends StateNotifier<AdminState> {
  final AdminRepository _repository;

  AdminNotifier(this._repository) : super(AdminState()) {
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stats = await _repository.getPlatformStats();
      final users = await _repository.getAllUsers();
      final waitlist = await _repository.getWaitlist();
      state = state.copyWith(
        isLoading: false,
        stats: stats,
        users: users,
        waitlist: waitlist,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminProvider = StateNotifierProvider<AdminNotifier, AdminState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return AdminNotifier(repository);
});

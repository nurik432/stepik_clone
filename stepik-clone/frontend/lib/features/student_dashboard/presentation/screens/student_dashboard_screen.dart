// frontend/lib/features/student_dashboard/presentation/screens/student_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stepik_clone/features/auth/presentation/providers/auth_provider.dart';
import 'package:stepik_clone/features/student_dashboard/presentation/providers/student_provider.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stepik Clone'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Каталог'),
              Tab(text: 'Мои курсы'),
            ],
          ),
          actions: [
            if (ref.watch(authProvider).token != null) // Simplification: admin check would be better with user role
              IconButton(
                icon: const Icon(Icons.admin_panel_settings, color: Colors.red),
                tooltip: 'Панель администратора',
                onPressed: () => context.go('/admin'),
              ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(studentProvider.notifier).loadDashboard(),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Profile/Logout placeholder
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _ExploreTab(state: state),
            _MyCoursesTab(state: state),
          ],
        ),
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  final StudentState state;
  const _ExploreTab({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.allCourses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.allCourses.isEmpty) {
      return const Center(child: Text('Нет доступных курсов'));
    }
    return ListView.builder(
      itemCount: state.allCourses.length,
      itemBuilder: (context, index) {
        final course = state.allCourses[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.movie_creation_outlined),
            title: Text(course.title),
            subtitle: Text(course.isPaid ? 'Цена: \$${course.price}' : 'Бесплатно'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.go('/course/${course.id}'),
          ),
        );
      },
    );
  }
}

class _MyCoursesTab extends StatelessWidget {
  final StudentState state;
  const _MyCoursesTab({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.myEnrollments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.myEnrollments.isEmpty) {
      return const Center(child: Text('Вы пока не записаны ни на один курс'));
    }

    return ListView.builder(
      itemCount: state.myEnrollments.length,
      itemBuilder: (context, index) {
        final enrollment = state.myEnrollments[index];
        // In a real app, we'd find the course object for this enrollment
        // For now, let's assume we find it in allCourses or fetch it
        final course = state.allCourses.firstWhere(
          (c) => c.id == enrollment.courseId,
          orElse: () => state.allCourses[0], // fallback
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
            title: Text(course.title),
            subtitle: const Text('Продолжить обучение'),
            onTap: () => context.go('/course/${course.id}/learn'),
          ),
        );
      },
    );
  }
}

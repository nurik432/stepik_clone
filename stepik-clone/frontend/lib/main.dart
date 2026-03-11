// frontend/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/auth/presentation/providers/auth_provider.dart';
import 'package:stepik_clone/features/auth/presentation/screens/login_screen.dart';
import 'package:stepik_clone/features/auth/presentation/screens/register_screen.dart';
import 'package:stepik_clone/features/admin_panel/presentation/screens/admin_dashboard_screen.dart';
import 'package:stepik_clone/features/student_dashboard/presentation/screens/course_details_screen.dart';
import 'package:stepik_clone/features/student_dashboard/presentation/screens/lesson_viewer_screen.dart';
import 'package:stepik_clone/features/student_dashboard/presentation/screens/student_dashboard_screen.dart';
import 'package:stepik_clone/features/teacher_panel/presentation/screens/course_editor_screen.dart';
import 'package:stepik_clone/features/teacher_panel/presentation/screens/lesson_editor/lesson_editor_screen.dart';
import 'package:stepik_clone/features/teacher_panel/presentation/screens/teacher_dashboard_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: StepikCloneApp(),
    ),
  );
}

class StepikCloneApp extends ConsumerWidget {
  const StepikCloneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = authState.token != null;
        final isAuthRoute = state.uri.toString() == '/login' || state.uri.toString() == '/register';

        if (!isLoggedIn && !isAuthRoute) return '/login';
        if (isLoggedIn && isAuthRoute) return '/dashboard';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const StudentDashboardScreen(),
        ),
        GoRoute(
          path: '/course/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CourseDetailsScreen(courseId: id);
          },
        ),
        GoRoute(
          path: '/course/:id/learn',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return LessonViewerScreen(courseId: id);
          },
        ),
        GoRoute(
          path: '/teacher',
          builder: (context, state) => const TeacherDashboardScreen(),
        ),
        GoRoute(
          path: '/teacher/course/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CourseEditorScreen(courseId: id);
          },
        ),
        GoRoute(
          path: '/teacher/lesson/:moduleId',
          builder: (context, state) {
            final moduleId = int.parse(state.pathParameters['moduleId']!);
            return LessonEditorScreen(moduleId: moduleId);
          },
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Stepik Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

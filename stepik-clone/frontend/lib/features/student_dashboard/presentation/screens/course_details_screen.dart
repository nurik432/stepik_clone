// frontend/lib/features/student_dashboard/presentation/screens/course_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stepik_clone/features/student_dashboard/presentation/providers/student_provider.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final int courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentProvider);
    final course = state.allCourses.firstWhere((c) => c.id == courseId);
    final isEnrolled = state.myEnrollments.any((e) => e.courseId == courseId);

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(course.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(course.description ?? 'Описание отсутствует'),
            const SizedBox(height: 24),
            const Text('Программа курса', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (course.modules.isEmpty)
              const Text('Программа пока не добавлена')
            else
              ...course.modules.map((m) => ListTile(
                    leading: const Icon(Icons.list),
                    title: Text(m.title),
                  )),
            const SizedBox(height: 80), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.isPaid ? '\$${course.price}' : 'Бесплатно', 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: isEnrolled 
                ? () => context.go('/course/$courseId/learn')
                : () => ref.read(studentProvider.notifier).enroll(courseId),
              child: Text(isEnrolled ? 'ПРОДОЛЖИТЬ' : (course.isPaid ? 'КУПИТЬ' : 'ЗАПИСАТЬСЯ')),
            ),
          ],
        ),
      ),
    );
  }
}

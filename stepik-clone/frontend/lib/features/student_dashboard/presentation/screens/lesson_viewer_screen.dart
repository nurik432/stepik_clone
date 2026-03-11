// frontend/lib/features/student_dashboard/presentation/screens/lesson_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stepik_clone/features/student_dashboard/presentation/providers/student_provider.dart';

class LessonViewerScreen extends ConsumerStatefulWidget {
  final int courseId;
  const LessonViewerScreen({super.key, required this.courseId});

  @override
  ConsumerState<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends ConsumerState<LessonViewerScreen> {
  int _currentModuleIndex = 0;
  int _currentLessonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentProvider);
    final course = state.allCourses.firstWhere((c) => c.id == widget.courseId);

    if (course.modules.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(course.title)),
        body: const Center(child: Text('В курсе пока нет модулей')),
      );
    }

    final module = course.modules[_currentModuleIndex];
    // In a real app modules would have lessons list attached in JSON
    // For now we assume a flat structure or fetch lessons for module
    // Let's use simplified logic for prototype
    
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        actions: [
          IconButton(icon: const Icon(Icons.list), onPressed: () {
            // Show course contents drawer or modal
          })
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: 0.3), // Mock overall progress
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(module.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  _buildContentMock(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          _buildNavigationFooter(),
        ],
      ),
    );
  }

  Widget _buildContentMock() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.black,
          child: const Center(child: Icon(Icons.play_circle_outline, size: 64, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        const Text(
          "В этом уроке мы изучим основы архитектуры Riverpod. "
          "Riverpod — это мощная библиотека управления состоянием для Flutter, "
          "которая исправляет многие недостатки Provider.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildNavigationFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: null, // Prev
            icon: const Icon(Icons.chevron_left),
            label: const Text('Назад'),
          ),
          ElevatedButton(
            onPressed: () {
              // ref.read(studentProvider.notifier).completeLesson(lessonId);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Прогресс сохранен!')));
            },
            child: const Text('ВЫПОЛНЕНО'),
          ),
          TextButton.icon(
            onPressed: () {}, // Next
            label: const Text('Далее'),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

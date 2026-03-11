// frontend/lib/features/teacher_panel/presentation/screens/teacher_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stepik_clone/features/teacher_panel/presentation/providers/teacher_provider.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teacherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель преподавателя'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(teacherProvider.notifier).loadCourses(),
          )
        ],
      ),
      body: state.isLoading && state.courses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.courses.isEmpty
              ? const Center(child: Text('У вас пока нет курсов. Создайте первый!'))
              : ListView.builder(
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    final course = state.courses[index];
                    return ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(course.title),
                      subtitle: Text(course.isPublished ? 'Опубликован' : 'Черновик'),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        ref.read(teacherProvider.notifier).selectCourse(course);
                        context.go('/teacher/course/${course.id}');
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCourseDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateCourseDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый курс'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Название курса'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Описание'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(teacherProvider.notifier).createCourse(
                    titleController.text,
                    descController.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}

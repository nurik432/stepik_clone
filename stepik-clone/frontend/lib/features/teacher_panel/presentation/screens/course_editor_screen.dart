// frontend/lib/features/teacher_panel/presentation/screens/course_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stepik_clone/features/teacher_panel/presentation/providers/teacher_provider.dart';

class CourseEditorScreen extends ConsumerStatefulWidget {
  final int courseId;
  const CourseEditorScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseEditorScreen> createState() => _CourseEditorScreenState();
}

class _CourseEditorScreenState extends ConsumerState<CourseEditorScreen> {
  void _showAddModuleDialog() {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый модуль'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Название модуля'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              final course = ref.read(teacherProvider).selectedCourse;
              if (course != null) {
                ref.read(teacherProvider.notifier).createModule(
                      course.id,
                      titleController.text,
                      course.modules.length, // порядок добавляется в конец
                    );
              }
              Navigator.pop(context);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teacherProvider);
    final course = state.selectedCourse;

    if (course == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Редактор: ${course.title}'),
        actions: [
          IconButton(
            icon: Icon(course.isPublished ? Icons.visibility : Icons.visibility_off),
            tooltip: course.isPublished ? 'Снять с публикации' : 'Опубликовать',
            onPressed: () {
              ref.read(teacherProvider.notifier).updateCourse(course.id, {
                'is_published': !course.isPublished,
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - настройки курса
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Настройки курса', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Платный курс'),
                    value: course.isPaid,
                    onChanged: (val) {
                      ref.read(teacherProvider.notifier).updateCourse(course.id, {'is_paid': val});
                    },
                  ),
                  if (course.isPaid)
                    ListTile(
                      title: Text('Цена: \$${course.price}'),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        // TODO: Изменить цену
                      },
                    ),
                  const Divider(),
                  const Text('Обложка: (в разработке)', style: TextStyle(color: Colors.grey)),
                  // TODO: Кнопка загрузки обложки в S3
                ],
              ),
            ),
          ),
          
          // Правая панель - Drag-and-drop модулей
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Модули курса', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Добавить модуль'),
                        onPressed: _showAddModuleDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: course.modules.isEmpty
                        ? const Center(child: Text('Нет модулей. Добавьте первый модуль.'))
                        : ReorderableListView(
                            onReorder: (oldIndex, newIndex) {
                              // В реальном проекте здесь нужно обновлять 'order' на бэкенде
                              // Для тестового задания просто перерисовываем UI
                            },
                            children: [
                              for (int i = 0; i < course.modules.length; i++)
                                Card(
                                  key: ValueKey(course.modules[i].id),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: const Icon(Icons.drag_handle),
                                    title: Text(course.modules[i].title),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        context.go('/teacher/lesson/${course.modules[i].id}');
                                      },
                                      tooltip: 'Добавить урок',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// frontend/lib/features/teacher_panel/presentation/screens/lesson_editor/lesson_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stepik_clone/features/teacher_panel/presentation/providers/lesson_provider.dart';

class LessonEditorScreen extends ConsumerStatefulWidget {
  final int moduleId;
  const LessonEditorScreen({super.key, required this.moduleId});

  @override
  ConsumerState<LessonEditorScreen> createState() => _LessonEditorScreenState();
}

class _LessonEditorScreenState extends ConsumerState<LessonEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedType = 'text'; // text, video, quiz

  // Для квиза (упрощенная структура для макета)
  List<Map<String, dynamic>> _quizQuestions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addQuizQuestion() {
    setState(() {
      _quizQuestions.add({
        'text': '',
        'type': 'single',
        'options': [
          {'text': 'Option 1', 'is_correct': true},
          {'text': 'Option 2', 'is_correct': false},
        ]
      });
    });
  }

  void _saveLesson() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите название урока')));
      return;
    }

    if (_selectedType == 'quiz') {
      ref.read(lessonProvider.notifier).createQuizLesson(
        widget.moduleId,
        _titleController.text,
        {'questions': _quizQuestions},
      );
    } else {
      ref.read(lessonProvider.notifier).createLessonAndContent(
        widget.moduleId,
        _titleController.text,
        _selectedType,
        _contentController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonProvider);

    ref.listen<LessonState>(lessonProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!)));
      } else if (next.currentLesson != null && previous?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Урок сохранен!')));
        context.pop(); // Возврат к курсу
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактор урока'),
        actions: [
          state.isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
              : IconButton(icon: const Icon(Icons.save), onPressed: _saveLesson),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название урока', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Тип урока', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'text', child: Text('Текст (Markdown)')),
                DropdownMenuItem(value: 'video', child: Text('Видео')),
                DropdownMenuItem(value: 'quiz', child: Text('Тест / Квиз')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: 24),
            if (_selectedType == 'text') _buildTextEditor(),
            if (_selectedType == 'video') _buildVideoUpload(),
            if (_selectedType == 'quiz') _buildQuizEditor(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextEditor() {
    return TextField(
      controller: _contentController,
      maxLines: 10,
      decoration: const InputDecoration(
        labelText: 'Контент (Markdown поддерживается)',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildVideoUpload() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Перетащите видео сюда или нажмите для выбора'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Имитация выбора файла
                setState(() {
                  _contentController.text = "uploaded_video.mp4";
                });
              },
              child: const Text('Выбрать файл (Mock)'),
            ),
            if (_contentController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Выбран файл: ${_contentController.text}', style: const TextStyle(color: Colors.green)),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildQuizEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Вопросы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (int i = 0; i < _quizQuestions.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Вопрос ${i + 1}'),
                    onChanged: (val) => _quizQuestions[i]['text'] = val,
                  ),
                  // Здесь должен быть список опций (упрощенно)
                  const SizedBox(height: 8),
                  const Text('Опции: (Упрощенный UI для Builder)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ElevatedButton.icon(
          onPressed: _addQuizQuestion,
          icon: const Icon(Icons.add),
          label: const Text('Добавить вопрос'),
        ),
      ],
    );
  }
}

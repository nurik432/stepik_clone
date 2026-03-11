// frontend/lib/features/lessons/domain/models/lesson.dart
class Lesson {
  final int id;
  final int moduleId;
  final String title;
  final int order;
  final String type; // video, text, quiz

  Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.order,
    required this.type,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      moduleId: json['module_id'],
      title: json['title'],
      order: json['order'],
      type: json['type'],
    );
  }
}

class LessonContent {
  final int id;
  final int lessonId;
  final String? videoUrl;
  final String? contentText;

  LessonContent({
    required this.id,
    required this.lessonId,
    this.videoUrl,
    this.contentText,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      id: json['id'],
      lessonId: json['lesson_id'],
      videoUrl: json['video_url'],
      contentText: json['content_text'],
    );
  }
}

class QuizOption {
  final int id;
  final String text;
  final bool isCorrect;

  QuizOption({required this.id, required this.text, this.isCorrect = false});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'],
      text: json['text'],
      isCorrect: json['is_correct'] ?? false,
    );
  }
}

class QuizQuestion {
  final int id;
  final String text;
  final String type; // single, multiple, boolean
  final List<QuizOption> options;

  QuizQuestion({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      options: (json['options'] as List?)
              ?.map((o) => QuizOption.fromJson(o))
              .toList() ??
          const [],
    );
  }
}

class Quiz {
  final int id;
  final int lessonId;
  final List<QuizQuestion> questions;

  Quiz({required this.id, required this.lessonId, this.questions = const []});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      lessonId: json['lesson_id'],
      questions: (json['questions'] as List?)
              ?.map((q) => QuizQuestion.fromJson(q))
              .toList() ??
          const [],
    );
  }
}

// frontend/lib/features/student_dashboard/domain/models/enrollment.dart
class Enrollment {
  final int id;
  final int userId;
  final int courseId;
  final DateTime enrolledAt;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      enrolledAt: DateTime.parse(json['enrolled_at']),
    );
  }
}

class Progress {
  final int id;
  final int userId;
  final int lessonId;
  final bool isCompleted;
  final DateTime completedAt;

  Progress({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.isCompleted,
    required this.completedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      userId: json['user_id'],
      lessonId: json['lesson_id'],
      isCompleted: json['is_completed'] ?? true,
      completedAt: DateTime.parse(json['completed_at']),
    );
  }
}

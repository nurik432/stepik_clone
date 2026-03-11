// frontend/lib/features/courses/domain/models/course.dart
class Module {
  final int id;
  final String title;
  final int order;

  Module({
    required this.id,
    required this.title,
    required this.order,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: json['title'],
      order: json['order'],
    );
  }
}

class Course {
  final int id;
  final String title;
  final String? description;
  final String? coverImageUrl;
  final int teacherId;
  final bool isPaid;
  final double price;
  final bool isPublished;
  final List<Module> modules;

  Course({
    required this.id,
    required this.title,
    this.description,
    this.coverImageUrl,
    required this.teacherId,
    required this.isPaid,
    required this.price,
    required this.isPublished,
    this.modules = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverImageUrl: json['cover_image_url'],
      teacherId: json['teacher_id'],
      isPaid: json['is_paid'] ?? false,
      price: (json['price'] ?? 0.0).toDouble(),
      isPublished: json['is_published'] ?? false,
      modules: (json['modules'] as List?)
              ?.map((e) => Module.fromJson(e))
              .toList() ??
          const [],
    );
  }
}

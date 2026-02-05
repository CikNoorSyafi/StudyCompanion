class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String createdBy;
  final DateTime date;
  final bool isPublished;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.date,
    this.isPublished = true,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? 'Admin',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      isPublished: json['isPublished'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdBy': createdBy,
      'date': date.toIso8601String(),
      'isPublished': isPublished,
    };
  }
}

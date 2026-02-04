class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String createdBy; // teacher/admin
  final DateTime date;
  final bool isPublished;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.date,
    required this.isPublished,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdBy: json['createdBy'] ?? '',
      date: DateTime.parse(json['date']),
      isPublished: json['isPublished'] ?? false,
    );
  }
}

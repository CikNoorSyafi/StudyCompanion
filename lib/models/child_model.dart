class ChildModel {
  final String id;
  final String name;
  final String grade;
  final double gpa;

  // 🆕 Learning data
  final String homework;
  final String quiz;
  final String reminder;

  ChildModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.gpa,
    required this.homework,
    required this.quiz,
    required this.reminder,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "Unknown",
      grade: json['grade'] ?? "N/A",
      gpa: (json['gpa'] ?? 0).toDouble(),
      homework: json['homework'] ?? "No homework",
      quiz: json['quiz'] ?? "No quiz",
      reminder: json['reminder'] ?? "No reminder",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'gpa': gpa,
      'homework': homework,
      'quiz': quiz,
      'reminder': reminder,
    };
  }
}

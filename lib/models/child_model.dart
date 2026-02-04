import 'subject_performance.dart';

class ChildModel {
  final String id;
  final String name;
  final String grade;
  final double gpa;

  final String homework;
  final String quiz;
  final String reminder;

  final List<SubjectPerformance> subjects;
  final int attendance;
  final String teacherRemark;

  ChildModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.gpa,
    required this.homework,
    required this.quiz,
    required this.reminder,
    required this.subjects,
    required this.attendance,
    required this.teacherRemark,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      grade: json['grade'] ?? "",
      gpa: (json['gpa'] ?? 0).toDouble(),
      homework: json['homework'] ?? "",
      quiz: json['quiz'] ?? "",
      reminder: json['reminder'] ?? "",
      subjects: (json['subjects'] as List? ?? [])
          .map((s) => SubjectPerformance.fromJson(s))
          .toList(),
      attendance: json['attendance'] ?? 0,
      teacherRemark: json['teacherRemark'] ?? "",
    );
  }
}

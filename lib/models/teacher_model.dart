class TeacherModel {
  final String id;
  final String name;
  final String subject;

  TeacherModel({
    required this.id,
    required this.name,
    required this.subject,
  });

  @override
  String toString() => 'TeacherModel(id: $id, name: $name, subject: $subject)';
import 'package:studycompanion_app/models/classroom_model.dart';

class TeacherModel {
  final String id;
  final String name;
  final List<ClassroomModel> classrooms;

  TeacherModel({required this.id, required this.name, List<ClassroomModel>? classrooms}) : classrooms = classrooms ?? [];

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      classrooms: (json['classrooms'] as List<dynamic>?)?.map((e) => ClassroomModel.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'classrooms': classrooms.map((c) => c.toJson()).toList(),
    };
  }
}

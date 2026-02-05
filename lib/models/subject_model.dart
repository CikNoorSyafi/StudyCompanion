import 'package:studycompanion_app/models/child_model.dart';
import 'package:studycompanion_app/models/task_model.dart';

class SubjectModel {
  final String id;
  final String name;
  final List<ChildModel> students;
  final List<TaskModel> tasks;

  SubjectModel({required this.id, required this.name, List<ChildModel>? students, List<TaskModel>? tasks}) :
    students = students ?? [],
    tasks = tasks ?? [];

  SubjectModel copyWith({String? id, String? name, List<ChildModel>? students, List<TaskModel>? tasks}) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      students: students ?? this.students,
      tasks: tasks ?? this.tasks,
    );
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      students: (json['students'] as List<dynamic>?)?.map((e) => ChildModel.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
      tasks: (json['tasks'] as List<dynamic>?)?.map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'students': students.map((s) => s.toJson()).toList(),
      'tasks': tasks.map((t) => t.toJson()).toList(),
    };
  }
}

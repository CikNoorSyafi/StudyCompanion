import 'package:studycompanion_app/models/subject_model.dart';

class ClassroomModel {
  final String id;
  final String name;
  final List<SubjectModel> subjects;
  bool archived;

  ClassroomModel({required this.id, required this.name, List<SubjectModel>? subjects, this.archived = false}) : subjects = subjects ?? [];

  ClassroomModel copyWith({String? id, String? name, List<SubjectModel>? subjects, bool? archived}) {
    return ClassroomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subjects: subjects ?? this.subjects,
      archived: archived ?? this.archived,
    );
  }

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subjects: (json['subjects'] as List<dynamic>?)?.map((e) => SubjectModel.fromJson(Map<String, dynamic>.from(e))).toList() ?? [],
      archived: json['archived'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((s) => s.toJson()).toList(),
      'archived': archived,
    };
  }
}

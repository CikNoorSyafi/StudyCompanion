class Task {
  final String id;
  final String title;
  final String dueDate;
  final String subject;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.subject,
    this.isCompleted = false,
  });

  // Create a copy with modifications
  Task copyWith({
    String? id,
    String? title,
    String? dueDate,
    String? subject,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      subject: subject ?? this.subject,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() => 'Task(id: $id, title: $title, dueDate: $dueDate, subject: $subject, isCompleted: $isCompleted)';
class TaskModel {
  final String id;
  final String title;
  final String type; // 'classroom','homework','assignment'
  final List<String> submissions; // student ids who submitted
  final List<String> assignedStudents; // student ids assigned to this task

  TaskModel({required this.id, required this.title, required this.type, List<String>? submissions, List<String>? assignedStudents}) :
    submissions = submissions ?? [],
    assignedStudents = assignedStudents ?? [];

  TaskModel copyWith({String? id, String? title, String? type, List<String>? submissions, List<String>? assignedStudents}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      submissions: submissions ?? this.submissions,
      assignedStudents: assignedStudents ?? this.assignedStudents,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? 'classroom',
      submissions: (json['submissions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      assignedStudents: (json['assignedStudents'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'submissions': submissions,
      'assignedStudents': assignedStudents,
    };
  }
}

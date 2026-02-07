class StudyTaskModel {
  final String id;
  final String studentId;
  String subject;
  String topic;
  DateTime date;
  int durationMinutes;
  bool completed;

  StudyTaskModel({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.topic,
    required this.date,
    required this.durationMinutes,
    this.completed = false,
  });
}

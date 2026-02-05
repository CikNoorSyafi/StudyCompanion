import '../models/teacher_model.dart';

class TeacherService {
  static Future<List<TeacherModel>> getTeachersForChildSubjects(
    List<String> subjects,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final allTeachers = [
      TeacherModel(id: "t1", name: "Mr. Adam", subject: "Math"),
      TeacherModel(id: "t2", name: "Ms. Lina", subject: "English"),
      TeacherModel(id: "t3", name: "Mr. Ravi", subject: "Science"),
      TeacherModel(id: "t4", name: "Ms. Mei", subject: "History"),
    ];

    return allTeachers
        .where((teacher) => subjects.contains(teacher.subject))
        .toList();
  }
}

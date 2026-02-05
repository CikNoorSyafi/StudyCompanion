import 'package:flutter/widgets.dart';
import 'package:studycompanion_app/models/teacher_model.dart';
import 'package:studycompanion_app/services/teacher_service.dart';

class TeacherStore extends ChangeNotifier {
  TeacherModel? _teacher;
  bool _loading = true;

  TeacherModel? get teacher => _teacher;
  bool get loading => _loading;

  TeacherStore() {
    _init();
  }

  Future<void> _init() async {
    _loading = true;
    notifyListeners();
    _teacher = await TeacherService.getTeacher();
    _loading = false;
    notifyListeners();
  }

  Future<void> reload() async {
    await _init();
  }

  // Proxy methods that update the underlying TeacherService and then refresh local copy
  Future<void> addClassroom(classroom) async {
    _teacher = await TeacherService.addClassroom(classroom);
    notifyListeners();
  }

  Future<void> deleteClassroom(String id) async {
    _teacher = await TeacherService.deleteClassroom(id);
    notifyListeners();
  }

  Future<void> toggleArchive(String id) async {
    _teacher = await TeacherService.toggleArchive(id);
    notifyListeners();
  }

  Future<void> addStudentToSubject(String classroomId, String subjectId, student) async {
    _teacher = await TeacherService.addStudentToSubject(classroomId, subjectId, student);
    notifyListeners();
  }

  Future<void> updateStudentInClassroom(String classroomId, student) async {
    _teacher = await TeacherService.updateStudentInClassroom(classroomId, student);
    notifyListeners();
  }

  Future<void> deleteStudentFromClassroom(String classroomId, String studentId) async {
    _teacher = await TeacherService.deleteStudentFromClassroom(classroomId, studentId);
    notifyListeners();
  }

  Future<void> addTaskToSubject(String classroomId, String subjectId, task) async {
    _teacher = await TeacherService.addTaskToSubject(classroomId, subjectId, task);
    notifyListeners();
  }

  Future<void> addSubjectToClassroom(String classroomId, subject) async {
    _teacher = await TeacherService.addSubjectToClassroom(classroomId, subject);
    notifyListeners();
  }

  Future<void> updateTaskInSubject(String classroomId, String subjectId, task) async {
    _teacher = await TeacherService.updateTaskInSubject(classroomId, subjectId, task);
    notifyListeners();
  }

  Future<void> deleteTaskFromSubject(String classroomId, String subjectId, String taskId) async {
    _teacher = await TeacherService.deleteTaskFromSubject(classroomId, subjectId, taskId);
    notifyListeners();
  }

  Future<void> toggleSubmission(String classroomId, String subjectId, String taskId, String studentId) async {
    _teacher = await TeacherService.toggleSubmission(classroomId, subjectId, taskId, studentId);
    notifyListeners();
  }
}

class TeacherProvider extends InheritedNotifier<TeacherStore> {
  const TeacherProvider({super.key, required super.notifier, required super.child}) : super();

  static TeacherStore of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<TeacherProvider>();
    if (provider == null) throw Exception('TeacherProvider not found in widget tree');
    return provider.notifier!;
  }
}

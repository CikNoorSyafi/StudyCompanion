import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studycompanion_app/services/teacher_service.dart';
import 'package:studycompanion_app/models/child_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TeacherService student CRUD', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('add, update, delete student in classroom', () async {
      final teacher = await TeacherService.getTeacher();
      expect(teacher.classrooms.isNotEmpty, true);
      final classroom = teacher.classrooms.first;
      final subject = classroom.subjects.first;

      final newStudent = ChildModel(id: 'test-stu', name: 'Test Student', grade: 'Grade X', gpa: 3.5, homework: '', quiz: '', reminder: '');

      final afterAdd = await TeacherService.addStudentToSubject(classroom.id, subject.id, newStudent);
      final clsAfterAdd = afterAdd.classrooms.firstWhere((c) => c.id == classroom.id);
      final subjAfterAdd = clsAfterAdd.subjects.firstWhere((s) => s.id == subject.id);
      expect(subjAfterAdd.students.any((s) => s.id == 'test-stu'), true);

      final updatedStudent = ChildModel(id: 'test-stu', name: 'Updated Name', grade: 'Grade X', gpa: 3.8, homework: '', quiz: '', reminder: '');
      final afterUpdate = await TeacherService.updateStudentInClassroom(classroom.id, updatedStudent);
      final clsAfterUpdate = afterUpdate.classrooms.firstWhere((c) => c.id == classroom.id);
      // all subjects in classroom should reflect updated student if present
      for (final s in clsAfterUpdate.subjects) {
        for (final st in s.students) {
          if (st.id == 'test-stu') expect(st.name, 'Updated Name');
        }
      }

      final afterDelete = await TeacherService.deleteStudentFromClassroom(classroom.id, 'test-stu');
      final clsAfterDelete = afterDelete.classrooms.firstWhere((c) => c.id == classroom.id);
      for (final s in clsAfterDelete.subjects) {
        expect(s.students.any((st) => st.id == 'test-stu'), false);
        for (final t in s.tasks) {
          expect(t.submissions.contains('test-stu'), false);
          expect(t.assignedStudents.contains('test-stu'), false);
        }
      }
    });
  });
}

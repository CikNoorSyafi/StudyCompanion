import 'package:studycompanion_app/models/teacher_model.dart';

class TeacherService {
  static Future<List<TeacherModel>> getTeachersForChildSubjects(
    List<String> subjects,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final allTeachers = [
      TeacherModel(id: "t1", name: "Cikgu Ahmad", subject: "Math"),
      TeacherModel(id: "t2", name: "Cikgu Suhana", subject: "English"),
      TeacherModel(id: "t3", name: "Cikgu Ravi", subject: "Science"),
      TeacherModel(id: "t4", name: "Cikgu Mei Ling", subject: "History"),
      TeacherModel(id: "t5", name: "Cikgu Farah", subject: "Bahasa Melayu"),
      TeacherModel(id: "t6", name: "Cikgu Zainul", subject: "Islamic Studies"),
    ];

    return allTeachers
        .where((teacher) => subjects.contains(teacher.subject))
        .toList();
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:studycompanion_app/models/teacher_model.dart';
import 'package:studycompanion_app/models/classroom_model.dart';
import 'package:studycompanion_app/models/subject_model.dart';
import 'package:studycompanion_app/models/child_model.dart';
import 'package:studycompanion_app/models/task_model.dart';

class TeacherService {
  // In-memory simulated store for teacher data so changes can persist during app runtime.
  static TeacherModel? _store;

  static Future<TeacherModel> _initializeIfNeeded() async {
    if (_store != null) return _store!;

    // try load from SharedPreferences first
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('teacher_store');
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _store = TeacherModel.fromJson(map);
        return _store!;
      } catch (_) {
        // fall through to create sample
      }
    }

    await Future.delayed(const Duration(milliseconds: 600));

    // generate larger sample dataset (seeder-like)
    final rnd = Random(42);

    // sample name parts to create varied student names
    final firstNames = ['Alex', 'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Ethan', 'Sophia', 'Mason', 'Isabella', 'Logan', 'Mia', 'Lucas', 'Amelia', 'Benjamin', 'Harper', 'James', 'Evelyn', 'Jacob', 'Abigail'];
    final lastNames = ['Johnson', 'Brown', 'Smith', 'Lee', 'Garcia', 'Martinez', 'Davis', 'Lopez', 'Wilson', 'Anderson'];
    final grades = ['Grade 1','Grade 2','Grade 3','Grade 4','Grade 5','Grade 6'];

    // create a pool of 80 students
    final students = List<ChildModel>.generate(80, (i) {
      final fn = firstNames[rnd.nextInt(firstNames.length)];
      final ln = lastNames[rnd.nextInt(lastNames.length)];
      final grade = grades[rnd.nextInt(grades.length)];
      final gpa = (2.5 + rnd.nextDouble() * 1.6).toStringAsFixed(2);
      return ChildModel(
        id: 's${i+1}',
        name: '$fn $ln',
        grade: grade,
        gpa: double.parse(gpa),
        homework: 'Homework for $grade',
        quiz: 'Quiz upcoming',
        reminder: 'Bring supplies',
      );
    });

    // subject pool
    final subjectNames = ['Math','Science','English','History','Art','Music','PE','Computer','Geography','Civics'];

    // create 6 classrooms each with 4-6 subjects and random students
    final classrooms = List<ClassroomModel>.generate(6, (ci) {
      final clsId = 'c${ci+1}';
  final clsName = '${ci + 4}${['A','B','C','D','E','F'][ci]} - ${ci % 2 == 0 ? 'Morning' : 'Afternoon'}';
      final subjectCount = 4 + rnd.nextInt(3); // 4-6
      final subjects = List<SubjectModel>.generate(subjectCount, (si) {
        final subId = '${clsId}_sub${si+1}';
        final subName = subjectNames[(ci + si) % subjectNames.length];
        // assign 8-20 students per subject
        final studentCount = 8 + rnd.nextInt(13);
        final selected = <ChildModel>[];
        for (var k = 0; k < studentCount; k++) {
          selected.add(students[(ci * 7 + si * 3 + k) % students.length]);
        }
        // create some tasks for the subject with randomized submissions
        final tasks = List<TaskModel>.generate(5 + rnd.nextInt(6), (ti) {
          final tId = '${subId}_t${ti+1}';
          final tType = ['classroom','homework','assignment'][rnd.nextInt(3)];
          // some students submitted
          final subs = <String>[];
          for (var s in selected) {
            if (rnd.nextDouble() < 0.6) subs.add(s.id); // ~60% submission rate
          }
          return TaskModel(id: tId, title: '$subName Task ${ti+1}', type: tType, submissions: subs);
        });

        return SubjectModel(id: subId, name: subName, students: selected, tasks: tasks);
      });

      return ClassroomModel(id: clsId, name: clsName, subjects: subjects);
    });

    _store = TeacherModel(id: 't1', name: 'Mrs. Smith', classrooms: classrooms);
    // persist initial store
    await _persistStore();
    return _store!;
  }

  // Public API
  static Future<TeacherModel> getTeacher() async {
    return await _initializeIfNeeded();
  }

  static Future<TeacherModel> addClassroom(ClassroomModel classroom) async {
    final t = await _initializeIfNeeded();
    // simulate delay
    await Future.delayed(const Duration(milliseconds: 200));
    _store = TeacherModel(id: t.id, name: t.name, classrooms: [...t.classrooms, classroom]);
    await _persistStore();
    return _store!;
  }

  static Future<TeacherModel> deleteClassroom(String classroomId) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    _store = TeacherModel(id: t.id, name: t.name, classrooms: t.classrooms.where((c) => c.id != classroomId).toList());
    await _persistStore();
    return _store!;
  }

  static Future<TeacherModel> toggleArchive(String classroomId) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updated = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      return c.copyWith(archived: !c.archived);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updated);
    await _persistStore();
    return _store!;
  }

  static Future<void> _persistStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_store == null) return;
      final raw = jsonEncode(_store!.toJson());
      await prefs.setString('teacher_store', raw);
    } catch (e) {
      // ignore persistence errors for now
    }
  }

  // Subject-level operations
  static Future<TeacherModel> addStudentToSubject(String classroomId, String subjectId, ChildModel student) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        if (s.id != subjectId) return s;
        final newStudents = [...s.students, student];
        return s.copyWith(students: newStudents);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  // Update a student across all subjects in a classroom (matching by id)
  static Future<TeacherModel> updateStudentInClassroom(String classroomId, ChildModel updatedStudent) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        final students = s.students.map((st) {
          if (st.id != updatedStudent.id) return st;
          return updatedStudent;
        }).toList();
        return s.copyWith(students: students);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  // Delete a student from all subjects in a classroom
  static Future<TeacherModel> deleteStudentFromClassroom(String classroomId, String studentId) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        final students = s.students.where((st) => st.id != studentId).toList();
        // also remove submissions referencing this student from tasks
        final tasks = s.tasks.map((task) {
          final subs = task.submissions.where((sid) => sid != studentId).toList();
          final assigned = task.assignedStudents.where((sid) => sid != studentId).toList();
          return task.copyWith(submissions: subs, assignedStudents: assigned);
        }).toList();
        return s.copyWith(students: students, tasks: tasks);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  static Future<TeacherModel> addTaskToSubject(String classroomId, String subjectId, TaskModel task) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        if (s.id != subjectId) return s;
        final newTasks = [...s.tasks, task];
        return s.copyWith(tasks: newTasks);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  // Add a new subject to a classroom
  static Future<TeacherModel> addSubjectToClassroom(String classroomId, SubjectModel subject) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final newSubjects = [...c.subjects, subject];
      return c.copyWith(subjects: newSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  static Future<TeacherModel> updateTaskInSubject(String classroomId, String subjectId, TaskModel updatedTask) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        if (s.id != subjectId) return s;
        final tasks = s.tasks.map((task) {
          if (task.id != updatedTask.id) return task;
          return updatedTask;
        }).toList();
        return s.copyWith(tasks: tasks);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  static Future<TeacherModel> deleteTaskFromSubject(String classroomId, String subjectId, String taskId) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        if (s.id != subjectId) return s;
        final tasks = s.tasks.where((task) => task.id != taskId).toList();
        return s.copyWith(tasks: tasks);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }

  static Future<TeacherModel> toggleSubmission(String classroomId, String subjectId, String taskId, String studentId) async {
    final t = await _initializeIfNeeded();
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedClassrooms = t.classrooms.map((c) {
      if (c.id != classroomId) return c;
      final updatedSubjects = c.subjects.map((s) {
        if (s.id != subjectId) return s;
        final updatedTasks = s.tasks.map((task) {
          if (task.id != taskId) return task;
          final submissions = List<String>.from(task.submissions);
          if (submissions.contains(studentId)) {
            submissions.remove(studentId);
          } else {
            submissions.add(studentId);
          }
          return task.copyWith(submissions: submissions);
        }).toList();
        return s.copyWith(tasks: updatedTasks);
      }).toList();
      return c.copyWith(subjects: updatedSubjects);
    }).toList();
    _store = TeacherModel(id: t.id, name: t.name, classrooms: updatedClassrooms);
    await _persistStore();
    return _store!;
  }
}

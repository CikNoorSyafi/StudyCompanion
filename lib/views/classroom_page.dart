import 'package:flutter/material.dart';
import 'package:studycompanion_app/views/subject_page.dart';
import 'package:studycompanion_app/services/teacher_store.dart';
import 'package:studycompanion_app/models/child_model.dart';
import 'package:studycompanion_app/models/subject_model.dart';

class ClassroomPage extends StatefulWidget {
  final String classroomId;
  const ClassroomPage({required this.classroomId, super.key});

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  @override
  Widget build(BuildContext context) {
    final store = TeacherProvider.of(context);
    if (store.loading || store.teacher == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final teacher = store.teacher!;
    final classroom = teacher.classrooms.firstWhere((c) => c.id == widget.classroomId, orElse: () => throw Exception('Classroom not found'));

    return Scaffold(
      appBar: AppBar(
        title: Text(classroom.name),
        backgroundColor: const Color(0xFF631018),
        actions: [
          IconButton(
            onPressed: () async {
              // Add student to classroom: prompt for details and which subjects to enroll
              final nameCtrl = TextEditingController();
              final gradeCtrl = TextEditingController();
              final gpaCtrl = TextEditingController();
              final subjects = classroom.subjects;
              final enroll = <String>{};
              final store = TeacherProvider.of(context);

              final res = await showDialog<Map<String, dynamic>?>(
                context: context,
                builder: (ctx) {
                  return StatefulBuilder(builder: (ctx2, setState) {
                    return AlertDialog(
                      title: const Text('Add Student to Classroom'),
                      content: SizedBox(
                        width: 480,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Full name')),
                            const SizedBox(height: 8),
                            TextField(controller: gradeCtrl, decoration: const InputDecoration(hintText: 'Grade')),
                            const SizedBox(height: 8),
                            TextField(controller: gpaCtrl, decoration: const InputDecoration(hintText: 'GPA (optional)')),
                            const SizedBox(height: 12),
                            const Align(alignment: Alignment.centerLeft, child: Text('Enroll in subjects:', style: TextStyle(fontWeight: FontWeight.bold))),
                            SizedBox(
                              height: 160,
                              child: ListView(
                                children: subjects.map((s) => CheckboxListTile(
                                  value: enroll.contains(s.id),
                                  onChanged: (v) => setState(() => v == true ? enroll.add(s.id) : enroll.remove(s.id)),
                                  title: Text(s.name),
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx2, null), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(ctx2, { 'name': nameCtrl.text.trim(), 'grade': gradeCtrl.text.trim(), 'gpa': gpaCtrl.text.trim(), 'enroll': enroll.toList() }), child: const Text('Add')),
                      ],
                    );
                  });
                }
              );

              if (!mounted) return;
              if (res != null) {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final name = (res['name'] as String).isEmpty ? 'Student $id' : (res['name'] as String);
                final grade = (res['grade'] as String).isEmpty ? 'N/A' : (res['grade'] as String);
                final gpa = double.tryParse((res['gpa'] as String)) ?? 0.0;
                final student = ChildModel(id: id, name: name, grade: grade, gpa: gpa, homework: '', quiz: '', reminder: '');
                final enrollList = (res['enroll'] as List<dynamic>).map((e) => e.toString()).toList();
                for (final sid in enrollList) {
                  await store.addStudentToSubject(widget.classroomId, sid, student);
                }
              }
            },
            icon: const Icon(Icons.person_add),
            tooltip: 'Add student',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Students (aggregated across subjects in the classroom)
            const Text('Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // Add a new subject to this classroom
                    final nameCtrl = TextEditingController();
                    final store = TeacherProvider.of(context);
                    final res = await showDialog<String?>(context: context, builder: (ctx) => AlertDialog(
                      title: const Text('New Subject'),
                      content: TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Subject name')),
                      actions: [TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(ctx, nameCtrl.text.trim()), child: const Text('Create'))],
                    ));
                    if (!mounted) return;
                    if (res != null && res.isNotEmpty) {
                      final id = '${widget.classroomId}_sub${DateTime.now().millisecondsSinceEpoch}';
                      final subject = SubjectModel(id: id, name: res);
                      await store.addSubjectToClassroom(widget.classroomId, subject);
                    }
                  },
                  icon: const Icon(Icons.book),
                  label: const Text('Add subject'),
                ),
                const SizedBox(width: 12),
              ],
            ),
            Builder(builder: (ctx) {
              final map = <String, ChildModel>{};
              for (final s in classroom.subjects) {
                for (final st in s.students) {
                  map[st.id] = st;
                }
              }
              final students = map.values.toList();
              if (students.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical:8), child: Text('No students in this classroom'));
              return Column(children: students.map((st) {
                return Card(
                  child: ListTile(
                    title: Text(st.name),
                    subtitle: Text(st.grade),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        final store = TeacherProvider.of(context);
                        if (v == 'edit') {
                          final nameCtrl = TextEditingController(text: st.name);
                          final gradeCtrl = TextEditingController(text: st.grade);
                          final gpaCtrl = TextEditingController(text: st.gpa.toString());
                          final res = await showDialog<bool?>(
                            context: context,
                            builder: (ctx2) => AlertDialog(
                              title: const Text('Edit student'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Full name')),
                                  const SizedBox(height: 8),
                                  TextField(controller: gradeCtrl, decoration: const InputDecoration(hintText: 'Grade')),
                                  const SizedBox(height: 8),
                                  TextField(controller: gpaCtrl, decoration: const InputDecoration(hintText: 'GPA')),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx2, false), child: const Text('Cancel')),
                                ElevatedButton(onPressed: () => Navigator.pop(ctx2, true), child: const Text('Save')),
                              ],
                            )
                          );
                          if (!mounted) return;
                          if (res == true) {
                            final updated = ChildModel(id: st.id, name: nameCtrl.text.trim(), grade: gradeCtrl.text.trim(), gpa: double.tryParse(gpaCtrl.text.trim()) ?? st.gpa, homework: st.homework, quiz: st.quiz, reminder: st.reminder);
                            await store.updateStudentInClassroom(widget.classroomId, updated);
                          }
                        } else if (v == 'delete') {
                          final conf = await showDialog<bool?>(context: context, builder: (ctx2) => AlertDialog(
                            title: const Text('Delete student'),
                            content: const Text('Remove this student from the classroom? This will delete them from all subjects in the classroom.'),
                            actions: [TextButton(onPressed: () => Navigator.pop(ctx2, false), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(ctx2, true), child: const Text('Delete'))],
                          ));
                          if (!mounted) return;
                          if (conf == true) {
                            await store.deleteStudentFromClassroom(widget.classroomId, st.id);
                          }
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                );
              }).toList());
            }),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(classroom.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (classroom.archived)
                  Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: const Text('Archived'))
              ],
            ),
            const SizedBox(height: 12),
            Text('${classroom.subjects.length} subject(s)', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ...classroom.subjects.map((s) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${s.students.length} student(s)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectPage(classroomId: classroom.id, subjectId: s.id)));
                },
              ),
            )),
            if (classroom.subjects.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('No subjects yet for this classroom.'))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:studycompanion_app/models/subject_model.dart';
import 'package:studycompanion_app/models/child_model.dart';
import 'package:studycompanion_app/models/task_model.dart';
import 'package:studycompanion_app/services/teacher_store.dart';

class SubjectPage extends StatefulWidget {
  final String classroomId;
  final String subjectId;
  const SubjectPage({required this.classroomId, required this.subjectId, super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {

  // Compute assigned and submitted counts for a specific type (within a subject)
  Map<String, int> _countsForType(SubjectModel s, String type) {
    int assigned = 0;
    int submitted = 0;
    for (final t in s.tasks.where((x) => x.type == type)) {
      assigned += t.assignedStudents.length;
      for (final sid in t.submissions) {
        if (t.assignedStudents.contains(sid)) submitted += 1;
      }
    }
    return {'assigned': assigned, 'submitted': submitted};
  }

  Future<void> _addStudent() async {
    final nameCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    final gpaCtrl = TextEditingController();

    final result = await showDialog<bool?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Full name')),
            TextField(controller: gradeCtrl, decoration: const InputDecoration(hintText: 'Grade')),
            TextField(controller: gpaCtrl, decoration: const InputDecoration(hintText: 'GPA (optional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
        ],
      ),
    );

    if (!mounted) return;
    if (result == true) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final name = nameCtrl.text.trim().isEmpty ? 'Student $id' : nameCtrl.text.trim();
      final grade = gradeCtrl.text.trim().isEmpty ? 'N/A' : gradeCtrl.text.trim();
      final gpa = double.tryParse(gpaCtrl.text.trim()) ?? 0.0;
      final student = ChildModel(id: id, name: name, grade: grade, gpa: gpa, homework: '', quiz: '', reminder: '');
      final store = TeacherProvider.of(context);
      await store.addStudentToSubject(widget.classroomId, widget.subjectId, student);
    }
  }

  Future<void> _addTask() async {
    final store = TeacherProvider.of(context);
    final teacher = store.teacher;
    if (teacher == null) return;

    // prepare classroom students list (unique)
    final cls = teacher.classrooms.firstWhere((c) => c.id == widget.classroomId);
    final studentMap = <String, ChildModel>{};
    for (final s in cls.subjects) {
      for (final st in s.students) {
        studentMap[st.id] = st;
      }
    }
    final studentsList = studentMap.values.toList();

    final titleCtrl = TextEditingController();
    String type = 'classroom';
    final selected = <String>{};

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, setState) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'Task title')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    items: const [
                      DropdownMenuItem(value: 'classroom', child: Text('Classroom Task')),
                      DropdownMenuItem(value: 'homework', child: Text('Homework')),
                      DropdownMenuItem(value: 'assignment', child: Text('Assignment')),
                    ],
                    onChanged: (v) { if (v != null) type = v; },
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  const SizedBox(height: 8),
                  const Align(alignment: Alignment.centerLeft, child: Text('Assign to students:', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      children: studentsList.map((st) => CheckboxListTile(
                        value: selected.contains(st.id),
                        onChanged: (v) => setState(() => v == true ? selected.add(st.id) : selected.remove(st.id)),
                        title: Text(st.name),
                        subtitle: Text(st.grade),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx2, null), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx2, { 'title': titleCtrl.text.trim(), 'type': type, 'assigned': selected.toList() }), child: const Text('Add')),
            ],
          );
        });
      }
    );

    if (!mounted) return;
    if (result != null) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final title = (result['title'] as String).isEmpty ? 'Task $id' : (result['title'] as String);
      final assigned = (result['assigned'] as List<dynamic>).map((e) => e.toString()).toList();
      final task = TaskModel(id: id, title: title, type: result['type'] as String, assignedStudents: assigned);
      await store.addTaskToSubject(widget.classroomId, widget.subjectId, task);
    }
  }

  Future<void> _editTask(TaskModel task) async {
    final store = TeacherProvider.of(context);
    final teacher = store.teacher;
    if (teacher == null) return;
    final cls = teacher.classrooms.firstWhere((c) => c.id == widget.classroomId);
    final studentMap = <String, ChildModel>{};
    for (final s in cls.subjects) {
      for (final st in s.students) {
        studentMap[st.id] = st;
      }
    }
    final studentsList = studentMap.values.toList();

    final titleCtrl = TextEditingController(text: task.title);
    String type = task.type;
    final selected = task.assignedStudents.toSet();

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, setState) {
          return AlertDialog(
            title: const Text('Edit Task'),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'Task title')),
                  const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                    items: const [
                      DropdownMenuItem(value: 'classroom', child: Text('Classroom Task')),
                      DropdownMenuItem(value: 'homework', child: Text('Homework')),
                      DropdownMenuItem(value: 'assignment', child: Text('Assignment')),
                    ],
                    onChanged: (v) { if (v != null) type = v; },
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  const SizedBox(height: 8),
                  const Align(alignment: Alignment.centerLeft, child: Text('Assigned students:', style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      children: studentsList.map((st) => CheckboxListTile(
                        value: selected.contains(st.id),
                        onChanged: (v) => setState(() => v == true ? selected.add(st.id) : selected.remove(st.id)),
                        title: Text(st.name),
                        subtitle: Text(st.grade),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx2, null), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx2, { 'title': titleCtrl.text.trim(), 'type': type, 'assigned': selected.toList() }), child: const Text('Save')),
            ],
          );
        });
      }
    );

    if (!mounted) return;
    if (result != null) {
      final updated = task.copyWith(
        title: (result['title'] as String).isEmpty ? task.title : (result['title'] as String),
        type: result['type'] as String,
        assignedStudents: (result['assigned'] as List<dynamic>).map((e) => e.toString()).toList(),
      );
      await store.updateTaskInSubject(widget.classroomId, widget.subjectId, updated);
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final confirm = await showDialog<bool?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Delete this task? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (!mounted) return;
    if (confirm == true) {
      final store = TeacherProvider.of(context);
      await store.deleteTaskFromSubject(widget.classroomId, widget.subjectId, taskId);
    }
  }

  Future<void> _toggleSubmission(String taskId, String studentId) async {
    final store = TeacherProvider.of(context);
    await store.toggleSubmission(widget.classroomId, widget.subjectId, taskId, studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (ctx) {
          final store = TeacherProvider.of(ctx);
          final teacher = store.teacher;
          String title = 'Subject';
          if (teacher != null) {
            try {
              final cls = teacher.classrooms.firstWhere((c) => c.id == widget.classroomId);
              final subj = cls.subjects.firstWhere((s) => s.id == widget.subjectId);
              title = subj.name;
            } catch (_) {}
          }
          return Text(title);
        }),
        backgroundColor: const Color(0xFF631018),
        actions: [
          IconButton(onPressed: _addStudent, icon: const Icon(Icons.person_add)),
          IconButton(onPressed: _addTask, icon: const Icon(Icons.note_add)),
        ],
      ),
      body: Builder(builder: (ctx) {
        final store = TeacherProvider.of(ctx);
        if (store.loading || store.teacher == null) return const Center(child: CircularProgressIndicator());
        final teacher = store.teacher!;
        final cls = teacher.classrooms.firstWhere((c) => c.id == widget.classroomId, orElse: () => throw Exception('Classroom not found'));
        final subj = cls.subjects.firstWhere((s) => s.id == widget.subjectId, orElse: () => throw Exception('Subject not found'));

            // build a map of classroom students for lookup by id
            final classStudentMap = <String, ChildModel>{};
            for (final s in cls.subjects) {
              for (final st in s.students) {
                classStudentMap[st.id] = st;
              }
            }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Submission Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(children: [
                        const Text('Classroom Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Builder(builder: (_) {
                          final counts = _countsForType(subj, 'classroom');
                          final map = {'Submitted': counts['submitted']!, 'Not submitted': (counts['assigned']! - counts['submitted']!).clamp(0, counts['assigned']!)};
                          return map.values.reduce((a,b) => a+b) == 0 ? const Text('No assigned tasks') : PieChartWidget(data: map);
                        }),
                      ]),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(children: [
                        const Text('Homeworks', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Builder(builder: (_) {
                          final counts = _countsForType(subj, 'homework');
                          final map = {'Submitted': counts['submitted']!, 'Not submitted': (counts['assigned']! - counts['submitted']!).clamp(0, counts['assigned']!)};
                          return map.values.reduce((a,b) => a+b) == 0 ? const Text('No assigned tasks') : PieChartWidget(data: map);
                        }),
                      ]),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(children: [
                        const Text('Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Builder(builder: (_) {
                          final counts = _countsForType(subj, 'assignment');
                          final map = {'Submitted': counts['submitted']!, 'Not submitted': (counts['assigned']! - counts['submitted']!).clamp(0, counts['assigned']!)};
                          return map.values.reduce((a,b) => a+b) == 0 ? const Text('No assigned tasks') : PieChartWidget(data: map);
                        }),
                      ]),
                    ),
                  )),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Tasks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              ...subj.tasks.map((task) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    title: Text(task.title),
                    subtitle: Text('${task.type} • ${task.assignedStudents.length} assigned'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'edit') _editTask(task);
                        if (v == 'delete') _deleteTask(task.id);
                      },
                      itemBuilder: (ctx2) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                    children: task.assignedStudents.map((sid) {
                      final st = classStudentMap[sid];
                      if (st == null) return ListTile(title: Text('Unknown student ($sid)'));
                      final submitted = task.submissions.contains(st.id);
                      return CheckboxListTile(
                        value: submitted,
                        onChanged: (_) => _toggleSubmission(task.id, st.id),
                        title: Text(st.name),
                        secondary: submitted ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.circle_outlined),
                      );
                    }).toList(),
                  ),
                );
              }),

              if (subj.tasks.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('No tasks yet')),
            ],
          ),
        );
      }),
    );
  }
}

// Minimal pie chart painter
class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;
  const PieChartWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (a, b) => a + b);
    final entries = data.entries.toList();
    // Map specific labels to desired colors: Submitted -> green, Not submitted -> pinkAccent
    final colors = entries.map((e) {
      final key = e.key.toLowerCase();
      if (key == 'submitted') return Colors.green;
      if (key.startsWith('not')) return Colors.red;
      return Colors.grey;
    }).toList();

    if (total == 0) return const Text('No submissions yet');

    // Render the pie with labels inside slices and a legend at the bottom
    return SizedBox(
      width: 260,
      // height accommodates pie + legend
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _PiePainter(entries: entries, colors: colors, total: total),
            ),
          ),
          const SizedBox(height: 8),
          // Bottom legend
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(entries.length, (i) {
                final e = entries[i];
                final pct = total > 0 ? (e.value / total * 100) : 0.0;
                final c = colors[i % colors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, color: c),
                      const SizedBox(width: 6),
                      Text('${e.key[0].toUpperCase()}${e.key.substring(1)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text('(${e.value} • ${pct.toStringAsFixed(0)}%)', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<MapEntry<String, int>> entries;
  final List<Color> colors;
  final int total;
  _PiePainter({required this.entries, required this.colors, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.fill;
    final center = rect.center;
    final radius = rect.width / 2;
    double startAngle = -3.141592653589793 / 2;
    for (var i = 0; i < entries.length; i++) {
      final value = entries[i].value.toDouble();
      final sweep = (value / total) * 3.141592653589793 * 2;
      paint.color = colors[i % colors.length];
      // draw slice
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep, true, paint);

      // draw label inside slice
      final midAngle = startAngle + sweep / 2;
      final labelRadius = radius * 0.6;
  final dx = center.dx + labelRadius * math.cos(midAngle);
  final dy = center.dy + labelRadius * math.sin(midAngle);
      final pct = total > 0 ? (value / total * 100) : 0.0;
      final label = '${entries[i].value}\n${pct.toStringAsFixed(0)}%';

      final textStyle = TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold);
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(dx - tp.width / 2, dy - tp.height / 2));

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

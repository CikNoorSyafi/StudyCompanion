import 'package:flutter/material.dart';
// models and services are accessed via TeacherStore (TeacherProvider)
import 'package:studycompanion_app/models/classroom_model.dart';
import 'package:studycompanion_app/views/classroom_page.dart';
import 'package:studycompanion_app/views/subject_page.dart';
import 'package:studycompanion_app/services/teacher_store.dart';

Widget sectionTitle(String text) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
);

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  static const primary = Color(0xFF631018);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  String? _selectedClassroomId;

  void _addClassroom() async {
    final nameController = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Classroom'),
        content: TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Classroom name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, nameController.text.trim()), child: const Text('Create')),
        ],
      ),
    );

  if (!mounted) return;
  if (result != null && result.isNotEmpty) {
      final newClass = ClassroomModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: result);
      final store = TeacherProvider.of(context);
      await store.addClassroom(newClass);
      setState(() {
        _selectedClassroomId = newClass.id;
      });
    }
  }

  void _deleteClassroom(String id) async {
    final confirm = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Classroom'),
        content: const Text('Are you sure you want to delete this classroom? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

  if (!mounted) return;
  if (confirm == true) {
      final store = TeacherProvider.of(context);
      await store.deleteClassroom(id);
      final teacher = store.teacher;
      setState(() {
        if (_selectedClassroomId == id) {
          _selectedClassroomId = teacher != null && teacher.classrooms.isNotEmpty ? teacher.classrooms.first.id : null;
        }
      });
    }
  }

  void _toggleArchive(String id) {
    final store = TeacherProvider.of(context);
    store.toggleArchive(id);
  }

  

  // Simple generated weekly submission stats for the chart. In real app, fetch real task/submission data.
  List<int> _sampleSubmittedForWeek(int totalStudents) => [
    totalStudents > 0 ? (totalStudents * 0.6).round() : 0,
    totalStudents > 0 ? (totalStudents * 0.5).round() : 0,
    totalStudents > 0 ? (totalStudents * 0.7).round() : 0,
    totalStudents > 0 ? (totalStudents * 0.4).round() : 0,
    totalStudents > 0 ? (totalStudents * 0.2).round() : 0,
    totalStudents > 0 ? (totalStudents * 0.55).round() : 0,
    totalStudents > 0 ? (totalStudents * 0.65).round() : 0,
  ];

  

  // Helpers for a specific classroom instance
  int _totalStudentsForClassroom(ClassroomModel cls) {
    final ids = <String>{};
    for (final subject in cls.subjects) {
      for (final s in subject.students) {
        ids.add(s.id);
      }
    }
    return ids.length;
  }

  List<int> _tasksForClassroom(ClassroomModel cls) {
    final subjectCount = cls.subjects.length;
    final base = subjectCount > 0 ? subjectCount : 1;
    return List.generate(7, (i) => base + (i % 3));
  }

  List<int> _submittedForClassroom(ClassroomModel cls) {
    final total = _totalStudentsForClassroom(cls);
    if (total == 0) return _sampleSubmittedForWeek(total);
    final factors = [0.6, 0.5, 0.7, 0.4, 0.2, 0.55, 0.65];
    return List<int>.generate(7, (i) => (total * factors[i]).round());
  }

  @override
  Widget build(BuildContext context) {
  // top-level totalStudents removed (we render per-classroom charts instead)

    final store = TeacherProvider.of(context);
    final teacher = store.teacher;
    final loading = store.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: AppBar(
        backgroundColor: TeacherDashboard.primary,
        title: Text(teacher?.name ?? 'Teacher Dashboard'),
        actions: [
          IconButton(onPressed: _addClassroom, icon: const Icon(Icons.add)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClassroom,
        backgroundColor: TeacherDashboard.primary,
        tooltip: 'Add Classroom',
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome Back\nCikgu Farah",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.notifications, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Dashboard", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
                children: [
                  const SizedBox(height: 12),

                  const SizedBox(height: 16),

                  // Section header with Add button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Expanded(child: Text('My Classrooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        ElevatedButton.icon(
                          onPressed: _addClassroom,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Classroom'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: teacher!.classrooms.map((c) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ClassroomPage(classroomId: c.id)));
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  Expanded(child: Text(c.name, style: TextStyle(fontWeight: FontWeight.bold, decoration: c.archived ? TextDecoration.lineThrough : null))),
                                  if (c.archived)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(padding: const EdgeInsets.symmetric(horizontal:6, vertical:2), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(6)), child: const Text('Archived', style: TextStyle(fontSize: 12))),
                                    )
                                ],
                              ),
                              subtitle: Text('${c.subjects.length} subject(s)'),
                              trailing: PopupMenuButton<String>(
                                onSelected: (v) {
                                  if (v == 'delete') _deleteClassroom(c.id);
                                  if (v == 'archive') _toggleArchive(c.id);
                                  if (v == 'students') {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => ClassroomPage(classroomId: c.id)));
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(value: 'students', child: Text('View students')),
                                  const PopupMenuItem(value: 'archive', child: Text('Archive/Unarchive')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                                ],
                              ),
                                      children: [
                                        // per-classroom small chart
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => ClassroomPage(classroomId: c.id)));
                                            },
                                            borderRadius: BorderRadius.circular(8),
                                            child: CombinationChart(
                                              days: ['M','T','W','T','F','S','S'],
                                              tasks: _tasksForClassroom(c),
                                              submitted: _submittedForClassroom(c),
                                              totalStudents: _totalStudentsForClassroom(c),
                                              chartHeight: 80,
                                            ),
                                          ),
                                        ),
                                        const Divider(height: 1),
                                        ...(
                                          c.subjects.isEmpty
                                              ? [const ListTile(title: Text('No subjects registered'))]
                                              : c.subjects.map((s) {
                                            return ListTile(
                                              title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                              subtitle: Text('${s.students.length} student(s)'),
                                              trailing: const Icon(Icons.chevron_right),
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectPage(classroomId: c.id, subjectId: s.id)));
                                              },
                                            );
                                          }).toList()
                                        )
                                      ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}

// Simple combination chart made from widgets (no external libs)
class CombinationChart extends StatelessWidget {
  final List<String> days;
  final List<int> tasks;
  final List<int> submitted;
  final int totalStudents;
  final double chartHeight;

  const CombinationChart({required this.days, required this.tasks, required this.submitted, required this.totalStudents, this.chartHeight = 120.0, super.key});

  @override
  Widget build(BuildContext context) {
    final maxTasks = (tasks.isNotEmpty ? tasks.reduce((a,b) => a>b?a:b) : 1);
    final maxValue = [maxTasks, totalStudents].reduce((a,b) => a>b?a:b).toDouble();
  final chartHeightLocal = chartHeight;

    return Column(
      children: [
        SizedBox(
          height: chartHeightLocal,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // line painter for tasks
                  CustomPaint(
                    size: Size(width, chartHeightLocal),
                    painter: _LinePainter(tasks: tasks, maxValue: maxValue, chartHeight: chartHeightLocal),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(days.length, (i) {
                      final submittedVal = submitted.length > i ? submitted[i].toDouble() : 0.0;
                      final notSubmittedVal = (totalStudents - submittedVal).clamp(0, totalStudents).toDouble();

                      final submittedHeight = (submittedVal / maxValue) * (chartHeight * 0.5);
                      final notSubmittedHeight = (notSubmittedVal / maxValue) * (chartHeight * 0.5);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // stacked bar for submitted vs not
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(width: 22, height: submittedHeight + notSubmittedHeight, color: Colors.grey[300]),
                              Container(width: 22, height: submittedHeight, color: Colors.green),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(days[i], style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            SizedBox(width: 8),
            Icon(Icons.stop, color: Colors.blueAccent, size: 12),
            SizedBox(width: 6),
            Text('Tasks'),
            SizedBox(width: 12),
            Icon(Icons.stop, color: Colors.green, size: 12),
            SizedBox(width: 6),
            Text('Submitted'),
            SizedBox(width: 12),
            Icon(Icons.stop, color: Colors.grey, size: 12),
            SizedBox(width: 6),
            Text('Not submitted'),
            SizedBox(width: 8),
          ],
        )
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<int> tasks;
  final double maxValue;
  final double chartHeight;

  _LinePainter({required this.tasks, required this.maxValue, required this.chartHeight});

  @override
  void paint(Canvas canvas, Size size) {
    if (tasks.isEmpty) return;
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..isAntiAlias = true;

    final pointPaint = Paint()..color = Colors.blueAccent;

    final path = Path();
    final step = size.width / tasks.length;

      for (var i = 0; i < tasks.length; i++) {
      final x = step * (i + 0.5);
      final value = tasks[i].toDouble();
      final y = size.height - ((value / maxValue) * (size.height * 0.5)) - 8;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      // draw point
      canvas.drawCircle(Offset(x, y), 3.0, pointPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 🔹 QUICK ACTION
class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const QuickAction({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: TeacherDashboard.primary),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// 🔹 TASK CARD
class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  const TaskCard(this.title, this.subtitle, this.progress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: TeacherDashboard.primary,
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// 🔹 ANNOUNCEMENT
class AnnouncementTile extends StatelessWidget {
  final String title;
  const AnnouncementTile(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(title),
      ),
    );
  }
}

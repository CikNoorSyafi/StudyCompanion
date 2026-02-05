import 'package:flutter/foundation.dart';
import 'package:studycompanion_app/models/task_model.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  late List<Task> _tasks;
  
  StudentDashboardViewModel() {
    _initializeTasks();
  }

  void _initializeTasks() {
    _tasks = [
      Task(
        id: '1',
        title: 'Algebra Worksheet',
        dueDate: 'Due Today',
        subject: 'Mathematics',
      ),
      Task(
        id: '2',
        title: 'Chapter 4 Reading',
        dueDate: 'Due Tomorrow',
        subject: 'English',
      ),
      Task(
        id: '3',
        title: 'Lab Report Draft',
        dueDate: 'Due Friday',
        subject: 'Science',
      ),
      Task(
        id: '4',
        title: 'History Essay Outline',
        dueDate: 'Next Week',
        subject: 'History',
      ),
    ];
  }

  List<Task> get tasks => _tasks;

  // Get overall progress percentage
  double get overallProgress {
    if (_tasks.isEmpty) return 0;
    int completedCount = _tasks.where((task) => task.isCompleted).length;
    return completedCount / _tasks.length;
  }

  // Get overall progress as percentage (0-100)
  int get progressPercentage => (overallProgress * 100).toInt();

  // Toggle task completion status
  void toggleTaskCompletion(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }

  // Get completed tasks count
  int get completedTasksCount => _tasks.where((task) => task.isCompleted).length;

  // Get total tasks count
  int get totalTasksCount => _tasks.length;

  // Get pending tasks count
  int get pendingTasksCount => _tasks.where((task) => !task.isCompleted).length;
}

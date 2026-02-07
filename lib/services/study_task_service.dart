import '../models/study_task_model.dart';

class StudyTaskService {
  static final List<StudyTaskModel> _tasks = [];

  static List<StudyTaskModel> getTasksByDate(DateTime date) {
    return _tasks
        .where(
          (t) =>
              t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day,
        )
        .toList();
  }

  static void addTask(StudyTaskModel task) {
    _tasks.add(task);
  }

  static void updateTask(StudyTaskModel updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) _tasks[index] = updated;
  }

  static void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  static void toggleComplete(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.completed = !task.completed;
  }
}

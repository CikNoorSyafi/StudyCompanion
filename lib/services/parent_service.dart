import '../models/child_model.dart';
import '../models/subject_performance.dart';

class ParentService {
  static Future<List<ChildModel>> getChildren() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      ChildModel(
        id: "1",
        name: "Alex Johnson",
        grade: "Grade 5",
        gpa: 3.8,
        homework: "Math Fractions Worksheet",
        quiz: "Science Chapter 5 • Tomorrow",
        reminder: "Bring calculator",
        subjects: [
          SubjectPerformance(subjectName: "Math", score: 92),
          SubjectPerformance(subjectName: "English", score: 85),
          SubjectPerformance(subjectName: "Science", score: 90),
        ],
        attendance: 96,
        teacherRemark: "Excellent performance",
      ),
      ChildModel(
        id: "2",
        name: "Emma Johnson",
        grade: "Grade 3",
        gpa: 4.0,
        homework: "English Essay",
        quiz: "Spelling Test • Friday",
        reminder: "Bring storybook",
        subjects: [
          SubjectPerformance(subjectName: "Math", score: 95),
          SubjectPerformance(subjectName: "English", score: 93),
        ],
        attendance: 98,
        teacherRemark: "Very consistent",
      ),
    ];
  }
}

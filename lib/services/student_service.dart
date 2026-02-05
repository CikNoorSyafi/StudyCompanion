import 'package:studycompanion_app/models/student_model.dart';

class StudentService {
  /// Get all students in the system
  static List<StudentModel> getAllStudents() {
    return [
      StudentModel(
        id: "s1",
        name: "Amir Abdullah",
        form: "Form 1",
        gender: "Boy",
        email: "amir.abdullah@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s2",
        name: "Muhammad Azhar",
        form: "Form 1",
        gender: "Boy",
        email: "azhar.muhammad@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s3",
        name: "Nur Azlina",
        form: "Form 1",
        gender: "Girl",
        email: "nur.azlina@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s4",
        name: "Siti Mariah",
        form: "Form 1",
        gender: "Girl",
        email: "siti.mariah@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s5",
        name: "Lim Wei Chen",
        form: "Form 2",
        gender: "Boy",
        email: "lim.weichen@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s6",
        name: "Raj Kumar",
        form: "Form 2",
        gender: "Boy",
        email: "raj.kumar@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s7",
        name: "Sophia Wong",
        form: "Form 2",
        gender: "Girl",
        email: "sophia.wong@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s8",
        name: "Priya Sharma",
        form: "Form 2",
        gender: "Girl",
        email: "priya.sharma@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s9",
        name: "Adnan Hassan",
        form: "Form 3",
        gender: "Boy",
        email: "adnan.hassan@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s10",
        name: "Tan Jun Wei",
        form: "Form 3",
        gender: "Boy",
        email: "tan.junwei@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s11",
        name: "Nurul Izzah",
        form: "Form 3",
        gender: "Girl",
        email: "nurul.izzah@school.edu.my",
        status: "Active",
      ),
      StudentModel(
        id: "s12",
        name: "Davina Ooi",
        form: "Form 3",
        gender: "Girl",
        email: "davina.ooi@school.edu.my",
        status: "Active",
      ),
    ];
  }

  /// Get students by form
  static List<StudentModel> getStudentsByForm(String form) {
    return getAllStudents().where((student) => student.form == form).toList();
  }

  /// Get students by gender
  static List<StudentModel> getStudentsByGender(String gender) {
    return getAllStudents().where((student) => student.gender == gender).toList();
  }

  /// Get a specific student by ID
  static StudentModel? getStudentById(String id) {
    try {
      return getAllStudents().firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get student count
  static int getStudentCount() {
    return getAllStudents().length;
  }

  /// Get student count by form
  static Map<String, int> getStudentCountByForm() {
    final students = getAllStudents();
    return {
      'Form 1': students.where((s) => s.form == 'Form 1').length,
      'Form 2': students.where((s) => s.form == 'Form 2').length,
      'Form 3': students.where((s) => s.form == 'Form 3').length,
    };
  }
}

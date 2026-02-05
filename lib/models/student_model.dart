class StudentModel {
  final String id;
  final String name;
  final String form;
  final String gender;
  final String email;
  final String status;

  StudentModel({
    required this.id,
    required this.name,
    required this.form,
    required this.gender,
    required this.email,
    required this.status,
  });

  // Convert StudentModel to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'form': form,
      'gender': gender,
      'email': email,
      'status': status,
    };
  }

  // Create StudentModel from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      form: json['form'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? 'Active',
    );
  }

  // Copy with method for immutability
  StudentModel copyWith({
    String? id,
    String? name,
    String? form,
    String? gender,
    String? email,
    String? status,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      form: form ?? this.form,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}

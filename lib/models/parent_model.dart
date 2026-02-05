class ParentModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final List<String> childrenIds; // IDs of children

  ParentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.childrenIds,
  });

  // Convert ParentModel to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'childrenIds': childrenIds,
    };
  }

  // Create ParentModel from JSON
  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'Parent',
      status: json['status'] ?? 'Active',
      childrenIds: List<String>.from(json['childrenIds'] ?? []),
    );
  }

  // Copy with method for immutability
  ParentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? status,
    List<String>? childrenIds,
  }) {
    return ParentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      childrenIds: childrenIds ?? this.childrenIds,
    );
  }
}

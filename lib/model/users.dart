class Users {
  final String id;
  final String email;
  final String name;

  Users({required this.id, required this.email, required this.name});
  factory Users.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data["name"] ?? "";
    final String email = data["email"] ?? "";
    return Users(name: name, email: email, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
    };
  }
}

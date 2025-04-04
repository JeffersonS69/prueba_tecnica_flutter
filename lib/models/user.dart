class UserModel {
  final String uid;
  final String email;
  final bool isAdmin;
  final String username;

  UserModel({
    required this.uid,
    required this.email,
    required this.isAdmin,
    required this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'isAdmin': isAdmin,
      'username': username,
    };
  }
}

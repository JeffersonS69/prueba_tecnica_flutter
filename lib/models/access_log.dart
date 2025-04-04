import 'package:cloud_firestore/cloud_firestore.dart';

class AccessLog {
  final String uid;
  final String email;
  final DateTime timestamp;
  final String username;

  AccessLog({
    required this.uid,
    required this.email,
    required this.timestamp,
    required this.username,
  });

  factory AccessLog.fromMap(Map<String, dynamic> data) {
    return AccessLog(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'timestamp': timestamp,
      'username': username,
    };
  }
}

import 'package:aplication/models/access_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccessLogController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logAccess(String uid, String email, String username) async {
    try {
      AccessLog accessLog = AccessLog(
        uid: uid,
        email: email,
        timestamp: DateTime.now(),
        username: username,
      );
      await _firestore.collection('access_logs').add(accessLog.toMap());
    } catch (e) {
      print("Error al registrar acceso: $e");
    }
  }

  Future<List<AccessLog>> getAccessLogs(String? email) async {
    try {
      final Query query;

      if (email != null) {
        query = _firestore
            .collection('access_logs')
            .where('email', isEqualTo: email);
      } else {
        query = _firestore
            .collection('access_logs')
            .orderBy('timestamp', descending: true);
      }

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        return AccessLog.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error al obtener registros de acceso: $e");
      return [];
    }
  }
}

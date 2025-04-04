import 'package:aplication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        return UserModel(
          uid: doc['uid'],
          email: doc['email'],
          isAdmin: doc['isAdmin'],
          username: doc['username'],
        );
      }).toList();
    } catch (e) {
      print("Error al obtener usuarios: $e");
      return [];
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      await _firestore
          .collection('access_logs')
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.delete();
            }
          });
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }

  Future<void> updateUser(String uid, bool? isAdmin, String? username) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isAdmin': isAdmin,
        'username': username,
      });

      Query query = _firestore
          .collection('access_logs')
          .where('uid', isEqualTo: uid);

      QuerySnapshot querySnapshot = await query.get();

      for (var doc in querySnapshot.docs) {
        await _firestore.collection('access_logs').doc(doc.id).update({
          'username': username,
        });
      }
    } catch (e) {
      print("Error al actualizar permisos de usuario: $e");
    }
  }
}

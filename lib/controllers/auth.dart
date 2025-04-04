import 'package:aplication/controllers/access_log.dart';
import 'package:aplication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final AccessLogController accessLogController = AccessLogController();

  Future<UserModel?> register(
    String email,
    String password,
    String username,
    bool isAdmin,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        isAdmin: isAdmin,
        username: username,
      );

      await _firestore
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      return newUser;
    } catch (e) {
      print("Error en el registro: $e");
      return null;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .then((doc) async {
            if (doc.exists) {
              await accessLogController.logAccess(
                userCredential.user!.uid,
                userCredential.user!.email!,
                doc['username'],
              );
              return UserModel.fromMap(doc.data()!);
            }
            return null;
          });
    } catch (e) {
      print("Error en el inicio de sesión: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}

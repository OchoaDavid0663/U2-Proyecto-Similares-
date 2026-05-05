import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ESTE MÉTODO DEBE EXISTIR:
  Future<User?> signUp(String email, String password) async {
    UserCredential res = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    return res.user;
  }
}
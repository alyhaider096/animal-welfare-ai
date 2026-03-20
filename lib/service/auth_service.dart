import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp({required String name, required String email, required String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await res.user?.updateDisplayName(name);
    return res.user;
  }

  Future<User?> signIn({required String email, required String password}) async {
    final res = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return res.user;
  }

  Future<void> signOut() => _auth.signOut();
}

import 'package:get/state_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;

  bool get isAuthenticated {
    user = FirebaseAuth.instance.currentUser;
    update();
    return user != null;
  }

  Future<bool> signUp(String name, String email, String password) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      user = userCredential.user;
      await user!.updateDisplayName(name);
      update();
      return true;
    }).catchError((error) {
      String errorMessage = 'An unknown error occured';

      switch (error.code) {
        case 'weak-password':
          errorMessage = 'Please use strong password';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email already linked to another account';
          break;
        case 'too-many-requests':
          errorMessage =
              'Account is disabled temporarily due to too many requests';
          break;
      }
      throw errorMessage;
    });
  }

  Future<bool> signIn(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      user = userCredential.user;
      update();
      return true;
    }).catchError((error) {
      String errorMessage = 'An unknown error occured';

      switch (error.code) {
        case 'user-not-found':
          errorMessage = 'User not found with the provided email';
          break;
        case 'wrong-password':
          errorMessage = 'Password was incorrect';
          break;
        case 'too-many-requests':
          errorMessage =
              'Account is disabled temporarily due to too many requests';
          break;
      }

      throw errorMessage;
    });
  }

  Future<bool> resetPassword(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      return true;
    }).catchError((error) {
      String errorMessage = 'An unknown error occured';

      switch (error.code) {
        case 'user-not-found':
          errorMessage = 'User not found with the provided email';
          break;
        case 'too-many-requests':
          errorMessage =
              'Account is disabled temporarily due to too many requests';
          break;
      }

      throw errorMessage;
    });
  }
}

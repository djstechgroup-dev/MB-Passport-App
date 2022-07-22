import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(authCredential);
      return userCredential.user;
    }
    return null;
  }

  Future<bool> checkUserAvailable() async {
    User? user = FirebaseAuth.instance.currentUser;

    if(user != null) {
      return true;
    }
    return false;
  }
}
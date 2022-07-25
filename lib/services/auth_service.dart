import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> saveUserData(User? user) async {
    //If fetching email failed, means user is available, do nothing.
    //If otherwise, set data for new user.
    try {
      String email = " ";
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user?.uid).get();
      email = snap['email'];
    } catch(e) {
      await FirebaseFirestore.instance.collection("Users").doc(user?.uid).set({
        'email': user?.email,
        'name': user?.displayName,
        'phone': user?.phoneNumber,
        'role': "Customer",
      });
    }
  }
}
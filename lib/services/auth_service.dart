import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/prefs_service.dart';

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
    User? user = auth.currentUser;

    if(user != null) {
      return true;
    }
    return false;
  }

  Future<void> saveUserData(User? user) async {
    //If fetching role failed, means user is not available, set data for new user.
    //If otherwise, do nothing.
    User? currentUser = auth.currentUser;

    try {
      String role = " ";
      String favoriteBusiness = " ";
      int savingsEarned = 0;
      int offersRedeemed = 0;
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user?.uid).get();
      role = snap['role'];
      favoriteBusiness = snap['favoriteBusiness'];
      savingsEarned = snap['savingsEarned'];
      offersRedeemed = snap['offersRedeemed'];

      PrefsService().saveUserData(
        UserData(
          uid: currentUser?.uid,
          displayName: currentUser?.displayName,
          email: currentUser?.email,
          phone: currentUser?.phoneNumber,
          role: role,
          favoriteBusiness: favoriteBusiness,
          savingsEarned: savingsEarned,
          offersRedeemed: offersRedeemed,
        ),
      );
    } catch(e) {
      await FirebaseFirestore.instance.collection("Users").doc(user?.uid).set({
        'email': user?.email,
        'name': user?.displayName,
        'phone': user?.phoneNumber,
        'role': "Customer",
        'favoriteBusiness': "",
        'savingsEarned': 0,
        'offersRedeemed': 0,
      });

      PrefsService().saveUserData(
        UserData(
          uid: currentUser?.uid,
          displayName: currentUser?.displayName,
          email: currentUser?.email,
          phone: currentUser?.phoneNumber,
          role: "Customer",
          favoriteBusiness: "",
          savingsEarned: 0,
          offersRedeemed: 0,
        ),
      );
    }
  }
}
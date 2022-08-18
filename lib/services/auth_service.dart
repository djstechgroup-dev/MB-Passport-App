import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/prefs_service.dart';
import 'package:http/http.dart' as http;

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

  Future<String> getUserToken(String? email) async {
    try {
      UserData user = UserData(
        email: email
      );
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/auth/signin_mobile');
      final headers = {
        "Content-Type": "application/json",
      };
      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(user),
      );

      final output = jsonDecode(response.body);
      if(response.statusCode == 200) {
        print("SUCCESS SIGN IN USER ${output['user']['email']}");
        print("USER TOKEN : ${output['token']}");
        return output['token'];
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<bool> checkUserAvailable() async {
    User? user = auth.currentUser;

    if(user != null) {
      return true;
    }
    return false;
  }

  Future<void> saveUserData(User? user, String token) async {
    User? currentUser = auth.currentUser;

    PrefsService().saveUserData(
      UserData(
        token: token,
        uid: currentUser?.uid,
        displayName: currentUser?.displayName,
        email: currentUser?.email,
        phone: currentUser?.phoneNumber,
      ),
    );
  }
}
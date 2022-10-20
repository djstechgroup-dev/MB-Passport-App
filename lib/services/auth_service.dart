import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passportapp/model/user.dart';
import 'package:passportapp/services/prefs_service.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  Future<User?> appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final appleCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      final userCredential = await auth.signInWithCredential(appleCredential);
      return userCredential.user;
    } catch(e) {
      throw Exception("Process aborted or failed.");
    }
  }

  Future<String> getUserToken(String? email, String? token) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      UserData user = UserData(
        email: email,
      );
      final uri = Uri.http('localhost:8000', '/api/auth/signin_mobile');
      final headers = {
        "Authorization": "Bearer $token",
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
        return output['user']['email'];
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

  Future<void> saveUserData(User? user, String? token) async {
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

  Future<UserData> getUserData(String? token) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('localhost:8000', '/api/me');
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };
      var response = await http.get(
        uri,
        headers: headers,
      );

      final output = jsonDecode(response.body);
      if(response.statusCode == 200) {
        return UserData.fromJson(output);
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }
}
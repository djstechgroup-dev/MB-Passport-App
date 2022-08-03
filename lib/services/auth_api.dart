import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passportapp/model/usertest.dart';

class AuthApi {
  Future<void> signUpUser(String email, String name, String favouriteBusiness, String offerRedeemed, String savedDeals, String savingsEarned, String password, DateTime date) async {
    try {
      UserTest user = UserTest(
        email: email,
        name: name,
        favouriteBusiness: favouriteBusiness,
        offerRedeemed: offerRedeemed,
        savedDeals: savedDeals,
        savingsEarned: savingsEarned,
        password: password,
        date: date,
      );

      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/mobile_signup');
      final headers = {
        "Content-Type": "application/json",
      };
      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(user),
      );

      if(response.statusCode == 200) {
        print("SUCCESS");
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<void> signInUser(String email, String password) async {
    try {
      UserTest user = UserTest(
        email: email,
        password: password,
      );

      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/mobile_signin');
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
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passportapp/model/business.dart';

class BusinessApi {
  Future<void> createBusiness(String businessName, String imageURL, String category, String address, String description, String tagline, int hourOpen, int hourClose, int totalOffers, int totalUsed) async {
    try {

      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('localhost:8000', '/api/create-business');
      final headers = {
        "Content-Type": "application/json",
      };
      var response = await http.post(
        uri,
        headers: headers,
      );

      if(response.statusCode == 200) {
        print("SUCCESSFULLY ADDED $businessName");
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAllBusiness(String? token) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('localhost:8000', '/api/business');
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
        List<dynamic> businesses = output['businesses'];
        return businesses;
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<BusinessData> getBusinessById(String? token, String? id) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('localhost:8000', '/api/business/$id');
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
        return BusinessData.fromJson(output);
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }
}
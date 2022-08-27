import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passportapp/model/businesstest.dart';

class BusinessApi {
  Future<void> createBusiness(String businessName, String imageURL, String category, String address, String description, String tagline, int hourOpen, int hourClose, int totalOffers, int totalUsed) async {
    try {
      BusinessTest business = BusinessTest(
        imageURL: imageURL,
        businessName: businessName,
        category: category,
        address: address,
        description: description,
        tagline: tagline,
        hourOpen: hourOpen,
        hourClose: hourClose,
        totalOffers: totalOffers,
        totalUsed: totalUsed,
      );

      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/create-business');
      final headers = {
        "Content-Type": "application/json",
      };
      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(business),
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

  Future<void> getBusiness(String businessName) async {

  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passportapp/model/deal.dart';

class DealApi {
  Future<List<dynamic>> getAllDeals(String? token) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/deals');
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
        // print(output['deals'][0]);
        // print(output['deals'][0]['locations'][0]['address']);
        // print(output['deals'][0]['businessId']['businessName']);
        List<dynamic> deals = output['deals'];
        // print(deals[0]['_id']);
        // print(deals[2]['_id']);
        return deals;
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<DealData> getDealById(String? token, String? id) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/deal/$id');
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
        // print(output['deal']);
        return DealData.fromJson(output);
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }
}
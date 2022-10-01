import 'package:http/http.dart' as http;

class FavoriteApi {
  void favoriteBusiness(String? token, String? id) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/favorite-business/$id');
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };
      var response = await http.patch(
        uri,
        headers: headers,
      );

      if(response.statusCode == 200) {
        print("Successfully added!");
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }

  void unFavoriteBusiness(String? token, String? id) async {
    try {
      //Temporary 10.0.2.2:8000 for testing using emulator
      final uri = Uri.http('10.0.2.2:8000', '/api/unfavorite-business/$id');
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      var response = await http.patch(
        uri,
        headers: headers,
      );

      if(response.statusCode == 200) {
        print("Successfully removed!");
      } else {
        throw Exception("ERROR WITH STATUS: ${response.statusCode}");
      }
    } catch(e) {
      rethrow;
    }
  }
}
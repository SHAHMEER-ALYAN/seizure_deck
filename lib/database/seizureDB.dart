import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../providers/user_provider.dart';

class SeizureService {
  static const String apiUrl = 'https://seizuredeck.000webhostapp.com/seizure.php';


  static Future<void> storeSeizureData() async {
    int? uid = UserProvider().uid;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'uid': uid.toString(),
          'date': DateTime.now(),
          'longitude': position.longitude.toString(),
          'latitude': position.latitude.toString()
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map && responseData.containsKey('message')) {
          print(responseData['message']);
        } else {
          // Handle other response scenarios if needed
          print("Invalid API response");
        }
      } else {
        print("Failed to connect to the server. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}

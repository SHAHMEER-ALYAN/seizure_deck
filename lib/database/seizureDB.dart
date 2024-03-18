import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SeizureService {
  static const String apiUrl = 'https://seizuredeck.000webhostapp.com/seizure.php';


  // static Future<void> storeSeizureData(String uid) async {
    static Future<void> storeSeizureData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? storedID = prefs.getInt("uid");
    // UserProvider userProvider = Provider.of(context,listen: false);
    // int? uid = userProvider.uid;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      print("UID is : ${storedID.toString()}");
      // Uri.parse('$apiUrl?uid=$uid');
      String date = DateTime.now().toString();
      print(date.substring(0,19));
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'uid': storedID.toString(),
          // 'type': type,
          'date': date.substring(0,19),
          'longitude': position.longitude.toString(),
          'latitude' : position.latitude.toString(),
        },
      );

      // final response = await http.post(
      //   Uri.parse(apiUrl),
      //   // headers: headers,
      //   body: {
      //     'uid': uid.toString(),
      //     'date': DateTime.now().toString(),
      //     'longitude': position.longitude.toString(),
      //     'latitude': position.latitude.toString(),
      //   },
      // );

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

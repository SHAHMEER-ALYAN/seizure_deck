import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/exercise_data.dart';

class ExerciseService {
  static const String apiUrl = 'https://seizuredeck.000webhostapp.com/get_exercise.php';

  static Future<List<Exercise>> getExercisesForUser(int uid) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?uid=$uid'), // Pass uid as a query parameter
      );
      print(" RESPONSE IS ${response.body}");

      if (response.body != null) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          print(responseData);
          return responseData.map((data) => Exercise.fromJson(data)).toList();
        } else {
          // Handle other response scenarios if needed
          print("Invalid JSON response");
          return [];
        }
      } else {
        print("Response body is null");
        return [];
      }
    } catch (e) {
      print("Exception: $e"); // Print the exception details
      print("here3");

      // Handle exceptions
      return [];
    }
  }
}

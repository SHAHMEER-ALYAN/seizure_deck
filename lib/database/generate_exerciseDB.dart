import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seizure_deck/data/exercise_data.dart';

late var exerciseList;

Future<void> generateExercise(
    String difficultySelect, int timeSelect, int spaceSelect, int equipmentSelect) async {
  const url = 'https://seizure-deck.000webhostapp.com/generate_exercise.php';

  final response = await http.get(
    Uri.parse('$url?difficulty=$difficultySelect&time_required=$timeSelect&space_required=$spaceSelect&equipment=$equipmentSelect'),
  );

  if (response.statusCode == 200) {
    // final responseBody = json.decode(response.body);
    // print(responseBody);
    final responseBody = json.decode(response.body);
    exerciseList = ExerciseList.fromJson(responseBody);
    print(exerciseList.runtimeType);

// Access the parsed data
    print(responseBody);

  } else {
    print("Failed to connect to the server. Status Code: ${response.statusCode}");
  }
}

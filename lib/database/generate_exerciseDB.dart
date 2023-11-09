import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  generateExercise("moderate", 60, 1, 0);
}

Future<void> generateExercise(
    String difficultySelect, int timeSelect, int spaceSelect, int equipmentSelect) async {
  const url = 'https://seizure-deck.000webhostapp.com/generate_exercise.php';

  final response = await http.get(
    Uri.parse('$url?difficulty=$difficultySelect&time_required=$timeSelect&space_required=$spaceSelect&equipment=$equipmentSelect'),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    print(responseBody);
  } else {
    print("Failed to connect to the server. Status Code: ${response.statusCode}");
  }
}

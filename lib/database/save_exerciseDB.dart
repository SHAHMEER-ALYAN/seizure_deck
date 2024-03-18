import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addToExercisePlan(int? uid, int? eid) async {
  if(uid == null || eid == null){
    return;
  }
  const url = 'https://seizure-deck.000webhostapp.com/save_exercise_plan.php';

  final response = await http.post(
    Uri.parse(url),
    body: {
      'uid': uid.toString(),
      'eid': eid.toString(),
    },
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    print(responseBody['message']);
  } else {
    print("Failed to connect to the server. Status Code: ${response.statusCode}");
  }
}

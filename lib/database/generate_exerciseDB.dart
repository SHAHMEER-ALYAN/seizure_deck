import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../data/exercise_data.dart';
import '../providers/exercise_provider.dart';

Future<void> generateExercise(
    BuildContext context,
    String type, // Add this parameter
    String difficultySelect,
    ) async {
  ExerciseProvider exerciseProvider =
  Provider.of<ExerciseProvider>(context, listen: false);

  const url = 'https://seizure-deck.000webhostapp.com/get_all_exercises.php';

  // final response = await http.get(
  //   Uri.parse(
  //       '$url?difficulty=$difficultySelect'),
  // );
  final response = await http.post(
    Uri.parse(url),
    body: {'type': type,
  'difficulty': difficultySelect},
  );

  if (response.statusCode == 200) {
    final dynamic responseData = json.decode(response.body);

    if (responseData is List) {
      // Convert the dynamic list to a list of Exercise
      List<Exercise> exercises =
      responseData.map((data) => Exercise.fromJson(data)).toList();

      exerciseProvider.setExercises(exercises);
    } else if (responseData is Map && responseData.containsKey('message')) {
      // Handle the case when no exercises are found
      print(responseData['message']);
      // You can display the message as needed, for example, show a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
        ),
      );
    }
  } else {
    print("Failed to connect to the server. Status Code: ${response.statusCode}");
  }
}
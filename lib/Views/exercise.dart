import 'package:flutter/material.dart';
import '../data/exercise_data.dart';
import 'generate_exercise_plan.dart';
import '../database/generate_exerciseDB.dart';

// import 'exercise_data.dart';

class exercise extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _exerciseState();
}

// final List<Map<String, String>> jsonData = responseBody;
class _exerciseState extends State<exercise> {
  List<Exercise> exercises = exerciseList;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(home: Scaffold(
      body: Center(
        child: exercises.isEmpty
        ? ElevatedButton(
        onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => generate_exercise_plan())); // Load exercises when the button is pressed
    },
      child: const Text("Generate Exercise Plan"),
    )
        : ListView.builder(
    itemCount: exercises.length,
    itemBuilder: (context, index) {
      Exercise exercise = exercises[index];
      return ListTile(
        title: Text('Exercise ID: ${exercise.eid}'),
        subtitle: Text('Exercise Name: ${exercise.eName}'),
        // Add other fields as needed
      );
      // ElevatedButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => generate_exercise_plan()));
      //   },child: const Text("Generate Exercise Plan"),
    }),
      ),
    ),
    );
  }
}

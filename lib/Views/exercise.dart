import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/database/save_exerciseDB.dart';
import '../data/exercise_data.dart';
import '../providers/exercise_provider.dart';
import '../providers/user_provider.dart';
import 'generate_exercise_plan.dart';
import '../database/generate_exerciseDB.dart';

class exercise extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _exerciseState();
}

class _exerciseState extends State<exercise> {
  @override
  Widget build(BuildContext context) {
    ExerciseProvider exerciseProvider = Provider.of<ExerciseProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return MaterialApp(
      home: Scaffold(
        body: exerciseProvider.exercises.isEmpty
            ? Center(
              child: ElevatedButton(
          onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => generate_exercise_plan()));
          },
          child: const Text("Generate Exercise Plan"),
        ),
            )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: exerciseProvider.exercises.length,
                itemBuilder: (context, index) {
                  Exercise exercise = exerciseProvider.exercises[index];
                  return ListTile(
                    title: Center(child: Text('Exercise ID: ${exercise.eid}')),
                    subtitle: Text(
                        'Exercise Name: ${exercise.eName} \n'
                            'Time Required: ${exercise.timeRequired} \n'
                            'Space Required: ${exercise.spaceRequired}'),
                    // Add other fields as needed
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                for (int i = 0; i < exerciseProvider.exercises.length; i++) {
                  addToExercisePlan(userProvider.uid, exerciseProvider.exercises[i].eid);
                }
              },
              child: Text("Upload Exercise Plan"),
            ),
          ],
        ),
      ),
    );
  }
}

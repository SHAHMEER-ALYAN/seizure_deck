import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/providers/exercise_provider.dart';

import '../data/exercise_data.dart';
import '../database/save_exerciseDB.dart';
import '../providers/user_provider.dart';


class exerciseList extends StatefulWidget {
  const exerciseList({Key? key}) : super(key: key);

  @override
  State<exerciseList> createState() => _exerciseList();
}

class _exerciseList extends State<exerciseList> {

  List<int> selectedExerciseIds = [];


  @override
  Widget build(BuildContext context) {
    ExerciseProvider exerciseProvider = Provider.of<ExerciseProvider>(context);

    UserProvider userProvider = Provider.of<UserProvider>(
        context, listen: false);

    return MaterialApp(
        home: Scaffold(
        body: Column(
        children: [
        ListView.builder(
        itemCount: exerciseProvider.exercises.length,
        itemBuilder: (context, index)
    {
      Exercise exercise = exerciseProvider.exercises[index];
      bool isSelected = selectedExerciseIds.contains(exercise.eid);
      return ListTile(
          title: Center(child: Text('Exercise ID: ${exercise.eid}')),
          subtitle: Text(
              'Exercise Name: ${exercise.eName} \n'
                  'Time Required: ${exercise.timeRequired} \n'
                  'Space Required: ${exercise.spaceRequired}'),
        trailing: IconButton(
          icon: isSelected
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
          onPressed: () {
            setState(() {
              if (isSelected) {
                selectedExerciseIds.remove(exercise.eid);
              } else {
                selectedExerciseIds.add(exercise.eid as int);
              }
            });
          },
        ),
      );
    },
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

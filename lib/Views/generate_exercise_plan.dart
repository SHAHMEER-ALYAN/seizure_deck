import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/cupertino.dart';

import '../database/generate_exerciseDB.dart';

class generate_exercise_plan extends StatefulWidget {
  const generate_exercise_plan({Key? key}) : super(key: key);

  @override
  State<generate_exercise_plan> createState() => _generate_exercise_plan();
}

class _generate_exercise_plan extends State<generate_exercise_plan> {
  int time_select = 15;
  int space_select = 0;
  int equipment_select = 0;
  String difficulty_select = "easy";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Difficulty",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 15,
              fontSize: 20,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              inactiveFgColor: Colors.grey[900],
              inactiveBgColor: Colors.grey,
              activeBgColor: const [Color(0xFF454587)],
              activeFgColor: const Color(0xFF00c8dd),
              totalSwitches: 3,
              labels: const ['Easy', 'Moderate', 'Hard'],
              onToggle: (valueSelector) {
                if (valueSelector == 0) {
                  difficulty_select = "easy";
                } else if (valueSelector == 1) {
                  difficulty_select = "moderate";
                } else if (valueSelector == 2) {
                  difficulty_select = "hard";
                }
                print(difficulty_select);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Per Exercise Time",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 15,
              fontSize: 20,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              inactiveFgColor: Colors.grey[900],
              inactiveBgColor: Colors.grey,
              activeBgColor: const [Color(0xFF454587)],
              activeFgColor: const Color(0xFF00c8dd),
              totalSwitches: 3,
              labels: const ['15', '30', '45'],
              onToggle: (value) {
                if (value == 0) {
                  time_select = 15;
                } else if (value == 1) {
                  time_select = 30;
                } else if (value == 2) {
                  time_select = 45;
                } else {
                  print("invalid option");
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Space Available",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 15,
              fontSize: 20,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              inactiveFgColor: Colors.grey[900],
              inactiveBgColor: Colors.grey,
              activeBgColor: const [Color(0xFF454587)],
              activeFgColor: const Color(0xFF00c8dd),
              totalSwitches: 2,
              labels: const ['No Space', 'Space Available'],
              onToggle: (space_select) {
                print("Space Status: $space_select");
              },
            ),
            SizedBox(height: 20,),
            Text("Equipment Availability"),
            ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 15,
              fontSize: 20,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              inactiveFgColor: Colors.grey[900],
              inactiveBgColor: Colors.grey,
              activeBgColor: const [Color(0xFF454587)],
              activeFgColor: const Color(0xFF00c8dd),
              totalSwitches: 2,
              labels: const ['No Equipment', 'Equipment Available'],
              onToggle: (equipment_select) {
                print("Equipment Status: $equipment_select");
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              print("$difficulty_select $time_select $space_select , $equipment_select");
              generateExercise(difficulty_select,time_select,space_select,equipment_select);
            }, child: const Text("Create Exercise Plan")),
          ],
        )),
      ),
    );
  }
}

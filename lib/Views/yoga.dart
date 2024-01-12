import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/exercise_list.dart';
import 'package:seizure_deck/database/generate_exerciseDB.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../data/exercise_data.dart';

class Yoga extends StatefulWidget {
  const Yoga({Key? key}) : super(key: key);

  @override
  State<Yoga> createState() => _YogaState();
}

class _YogaState extends State<Yoga> {
  String gender = 'MALE';
  String experience = "Easy";
  int duration = 3;
  int numOfExercises = 4;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Gender"),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height / 15,
                fontSize: 20,
                customTextStyles: const [
                  TextStyle(fontWeight: FontWeight.bold),
                ],
                inactiveFgColor: Colors.grey[900],
                inactiveBgColor: Colors.grey,
                activeBgColor: const [Color(0xFF454587)],
                activeFgColor: const Color(0xFF00c8dd),
                totalSwitches: 2,
                labels: ["MALE", "FEMALE"],
                onToggle: (value1) {
                  gender = value1 == 0 ? "MALE" : "FEMALE";
                },
              ),
              const SizedBox(height: 20),
              const Text("Select Your Experience"),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height / 15,
                fontSize: 20,
                customTextStyles: const [
                  TextStyle(fontWeight: FontWeight.bold),
                ],
                inactiveFgColor: Colors.grey[900],
                inactiveBgColor: Colors.grey,
                activeBgColor: const [Color(0xFF454587)],
                activeFgColor: const Color(0xFF00c8dd),
                totalSwitches: 3,
                labels: const ["Beginner", "Intermediate", "Advanced"],
                onToggle: (value2) {
                  experience = value2 == 0
                      ? "Easy"
                      : value2 == 1
                      ? "Moderate"
                      : "Hard";
                },
              ),
              const SizedBox(height: 20),
              const Text("Select Total Duration For Each Exercise (minutes)"),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height / 15,
                fontSize: 20,
                customTextStyles: const [
                  TextStyle(fontWeight: FontWeight.bold),
                ],
                inactiveFgColor: Colors.grey[900],
                inactiveBgColor: Colors.grey,
                activeBgColor: const [Color(0xFF454587)],
                activeFgColor: const Color(0xFF00c8dd),
                totalSwitches: 3,
                labels: const ["3", "4", "5"],
                onToggle: (value3) {
                  if(value3==0){
                    duration = 3;
                  }
                  else if(value3==1){
                    duration = 4;
                  }else if(value3==2){
                    duration = 5;
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text("Select Number of Exercises"),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height / 15,
                fontSize: 20,
                customTextStyles: const [
                  TextStyle(fontWeight: FontWeight.bold),
                ],
                inactiveFgColor: Colors.grey[900],
                inactiveBgColor: Colors.grey,
                activeBgColor: const [Color(0xFF454587)],
                activeFgColor: const Color(0xFF00c8dd),
                totalSwitches: 4,
                labels: const ["4", "5", "6", "7"],
                onToggle: (value4) {
                  numOfExercises = value4! + 4; // Adjust the range to 4-7
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  print(experience);
                  await generateExercise(
                      context, "Yoga", experience, duration, numOfExercises);
                  print('yo');
                  setState(() {
                    loading = false;
                  });
                  if (loading == false) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseListScreen(),
                      ),
                    );
                  }
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Generate Yoga Plan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

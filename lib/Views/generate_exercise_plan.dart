import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/exercise.dart';
import 'package:seizure_deck/Views/exercise_list.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/providers/exercise_provider.dart'; // Adjust the import based on your project structure

import '../database/generate_exerciseDB.dart';

class generate_exercise_plan extends StatefulWidget {
  const generate_exercise_plan({Key? key}) : super(key: key);

  @override
  State<generate_exercise_plan> createState() => _generate_exercise_plan();
}

class _generate_exercise_plan extends State<generate_exercise_plan> {
  late int exercise_count = 3;
  late String diff_select = "Easy";
  late String mode_select = "Cardio";
  bool diff_lock = false;
  bool loading = false;

  final GlobalKey toggleSwitchKey = GlobalKey();

  @override
  void initState(){
    super.initState();
    Diffculity_Select_Widget;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFF454587),
                  minimumSize: Size(MediaQuery.of(context).size.width / 1.5,
                      MediaQuery.of(context).size.width / 10)
              ))
      ),
      home: Scaffold(
        body: ChangeNotifierProvider(
            create: (context) => ExerciseProvider(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Select Exercise Type",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20,),
                  ToggleSwitch(
                    key: toggleSwitchKey,
                    minHeight: MediaQuery.of(context).size.height/15,
                    minWidth: MediaQuery.of(context).size.width,
                    fontSize: 20,
                    customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
                    inactiveFgColor: Colors.grey[900],
                    inactiveBgColor: Colors.grey,
                    activeBgColor: const [Color(0xFF454587)],
                    activeFgColor: const Color(0xFF00c8dd),
                    totalSwitches: 3,
                    labels: ["Cardio", "Tai Chi", "Yoga"],
                    onToggle: (value1) {
                      if (value1 == 0) {
                        mode_select = "Cardio";
                        print(mode_select);
                        // Locker(false);
                      } else if (value1 == 1) {
                        mode_select = "Tai Chi";
                        print(mode_select);
                        // Locker(true);
                      } else if (value1 == 2) {
                        mode_select = "Yoga";
                        print(mode_select);
                        // Locker(false);
                      }
                    },

                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Difficulty Level",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20,),
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
                    onToggle: (mode) {
                      if (mode == 0) {
                        diff_select = 'Easy';
                        print(diff_select);
                      } else if (mode == 1) {
                        diff_select = 'Moderate';
                        print(diff_select);
                      } else if (mode == 2) {
                        diff_select = 'Hard';
                        print(diff_select);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Number of Exercises",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ToggleSwitch(minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height / 15,
                    fontSize: 20,
                    customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
                    inactiveFgColor: Colors.grey[900],
                    inactiveBgColor: Colors.grey,
                    activeBgColor: const [Color(0xFF454587)],
                    activeFgColor: const Color(0xFF00c8dd),
                    totalSwitches: 3,
                    labels: ["3","4","5"],
                    onToggle: (value2) {
                    if(value2 == 0){
                      exercise_count = 3;
                    }else if(value2 == 1){
                      exercise_count = 4;
                    }else if(value2 == 2){
                      exercise_count = 5;
                    }
                    },
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      print("$mode_select $diff_select $exercise_count");
                      if(mode_select == "Tai Chi"){
                        print("Tai Chi is Selected");
                        diff_select = "Easy";
                      }
                      await generateExercise(context,mode_select, diff_select);

                      setState(() {
                        loading = false;
                      });
                      if (loading == false) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const exerciseList()));
                        print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
                      }
                    },
                    child: const Text("Create Exercise Plan"),
                  ),
                  if (loading) CircularProgressIndicator(),
                  // ElevatedButton(onPressed: () async {
                  //   print("$difficulty_select $time_select $space_select , $equipment_select");
                  //   await generateExercise(difficulty_select,time_select,space_select,equipment_select);
                  // }, child: const Text("Create Exercise Plan")),
                ],
              ),
            )),
      ),
    );
  }

  Locker(bool cc) {
  setState(() {
    diff_lock = cc;
  });
  }


  Widget Diffculity_Select_Widget() {
    return Container(
      child: Column(
        children: [
          Text("Select Difficulty",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
            onToggle: (mode) {
              if (mode == 0) {
                diff_select = 'Easy';
                print(diff_select);
              } else if (mode == 1) {
                diff_select = 'Moderate';
                print(diff_select);
              } else if (mode == 2) {
                diff_select = 'Hard';
                print(diff_select);
              }
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/exercise.dart';
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
  late int time_select = 15;
  late int space_select = 0;
  late int equipment_select = 0;
  late String difficulty_select = "easy";
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => ExerciseProvider(),
            child: Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                onToggle: (valuespace) {
                  if(valuespace==0){
                    space_select=0;
                  }else if(valuespace==1){
                    space_select =1;
                  }
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
                onToggle: (valuedemo) {
                  if(valuedemo==0){
                    equipment_select = 0;
                  }else if(valuedemo == 1){
                    equipment_select = 1;
                  }
                  print("Equipment Status: $equipment_select");
                },
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  print("$difficulty_select $time_select $space_select , $equipment_select");
                  await generateExercise(context,difficulty_select, time_select, space_select, equipment_select);


                  setState(() {
                    loading = false;
                  }
                  );
                  if(loading == false){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => exercise()));
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
}

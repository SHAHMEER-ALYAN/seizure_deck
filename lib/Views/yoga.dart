import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/exercise_list.dart';
import 'package:seizure_deck/database/generate_exerciseDB.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Yoga extends StatefulWidget {
  const Yoga({Key? key}) : super(key: key);

  @override
  State<Yoga> createState() => _Yoga();
}

class _Yoga extends State<Yoga> {
  String gender = 'MALE';
  String experience = "Beginner";
  int duration = 12;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Select Gender"),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height / 15,
                  fontSize: 20,
                  customTextStyles: const [
                    TextStyle(fontWeight: FontWeight.bold)
                  ],
                  inactiveFgColor: Colors.grey[900],
                  inactiveBgColor: Colors.grey,
                  activeBgColor: const [Color(0xFF454587)],
                  activeFgColor: const Color(0xFF00c8dd),
                  totalSwitches: 2,
                  labels: ["MALE", "FEMALE"],
                  onToggle: (value1) {
                    if (value1 == 0) {
                      gender = "MALE";
                    } else if (value1 == 1) {
                      gender = "FEMALE";
                    }
                  },
                ),
                SizedBox(height: 20,),
                const Text("Select Your Experience"),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height / 15,
                  fontSize: 20,
                  customTextStyles: const [
                    TextStyle(fontWeight: FontWeight.bold)
                  ],
                  inactiveFgColor: Colors.grey[900],
                  inactiveBgColor: Colors.grey,
                  activeBgColor: const [Color(0xFF454587)],
                  activeFgColor: const Color(0xFF00c8dd),
                  totalSwitches: 3,
                  labels: const ["Beginner","Intermediate", "Advanced"],
                  onToggle: (value2) {
                    if (value2 == 0) {
                      experience = "Beginner";
                    } else if (value2 == 1) {
                      experience = "Intermediate";
                    } else if (value2 == 2) {
                      experience = "Advanced";
                    }
                  },
                ),
                SizedBox(height: 20,),
                const Text("Select Total Duration For Full Yoga (minutes)"),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height / 15,
                  fontSize: 20,
                  customTextStyles: const [
                    TextStyle(fontWeight: FontWeight.bold)
                  ],
                  inactiveFgColor: Colors.grey[900],
                  inactiveBgColor: Colors.grey,
                  activeBgColor: const [Color(0xFF454587)],
                  activeFgColor: const Color(0xFF00c8dd),
                  totalSwitches: 3,
                  labels: const ["15","20", "25"],
                  onToggle: (value3) {
                    if (value3 == 0) {
                      duration = 15;
                    } else if (value3 == 1) {
                      duration = 20;
                    } else if (value3 == 2) {
                      duration = 25;
                    }
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await generateExercise(
                          context, "Yoga", experience, duration);
                      setState(() {
                        loading = false;
                      });
                      if (loading == false) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const exerciseList()));
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Generate Yoga Plan"))
              ],
            ),
          ),

      ),
    );
  }
}

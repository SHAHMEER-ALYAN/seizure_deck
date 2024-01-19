import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seizure_deck/Views/exercise_list.dart';
import 'package:seizure_deck/data/theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../database/generate_cardio.dart';

class bodySelect extends StatefulWidget {
  const bodySelect({Key? key}) : super(key: key);

  @override
  State<bodySelect> createState() => _bodySelect();
}

class _bodySelect extends State<bodySelect> {
  List<double> grey = [0.2126,    0.7152,    0.0722,    0,    0,
                      0.2126,    0.7152,    0.0722,    0,    0,
                      0.2126,    0.7152,    0.0722,    0,    0,
                      0,    0,    0,    1,    0,  ];

  bool shoulder  = false;
  bool chest = false;
  bool back = false;
  bool abs = false;
  bool arms = false;
  bool legs = false;
  int numOfExercise = 3;
  String difficulty = "Easy";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: FToastBuilder(),
      theme: ThemeManager.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF454587),
          // backgroundColor:  Color(0xFF00C8DD),
          centerTitle: true,
          title: const Text(
            "Exercises Catalogue",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:
          SingleChildScrollView(
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Body,
                  Column(
                    children: [
                      Body(),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 00),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              shoulder = !shoulder;
                            });
                            print(shoulder);
                            // chest = !chest;
                          },
                          child: Text('Shoulders')),
                      ElevatedButton(onPressed: () {
                        setState(() {
                          chest = !chest;
                        });
                        print(chest);
                      }, child: Text('Chest')),
                      ElevatedButton(onPressed: () {
                        setState(() {
                          back = !back;
                        });
                        print(back);
                      }, child: Text('Back')),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: () {
                        setState(() {
                          abs = !abs;
                        });
                        print(abs);
                      }, child: Text('Abs')),
                      ElevatedButton(onPressed: () {
                        setState(() {
                          arms = !arms;
                        });
                        print(arms);
                      }, child: Text('Arms')),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(onPressed: () {
                        setState(() {
                          legs = !legs;
                        });
                        print(legs);
                      }, child: Text('Legs')),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),
              Text('Select Number of Exercises'),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width/3,
                minHeight: MediaQuery.of(context).size.height / 18,
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
                onToggle: (value4) {
                  if(value4==0){
                    numOfExercise = 3;
                  }
                  else if(value4==1){
                    numOfExercise = 4;
                  }
                  else if(value4==2){
                    numOfExercise = 5;
                  }
                },
              ),
              SizedBox(height: 10,),
              Text('Select Difficulty of Exercises'),
              ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width/3,
                minHeight: MediaQuery.of(context).size.height / 18,
                fontSize: 20,
                customTextStyles: const [
                  TextStyle(fontWeight: FontWeight.bold),
                ],
                inactiveFgColor: Colors.grey[900],
                inactiveBgColor: Colors.grey,
                activeBgColor: const [Color(0xFF454587)],
                activeFgColor: const Color(0xFF00c8dd),
                totalSwitches: 3,
                labels: const ["Easy", "Moderate", "Hard"],
                onToggle: (value5) {
                  if(value5==0){
                    difficulty = "Easy";
                  }
                  else if(value5==1){
                    difficulty = "Moderate";
                  }
                  else if(value5==2){
                    difficulty = "Hard";
                  }
                },
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
              if(shoulder==true || chest == true || back == true || arms == true || abs == true || legs == true)
              {
              await generateCardioExercise(context,shoulder,chest,back,arms,abs,legs,numOfExercise,difficulty);
              print('CHECK');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExerciseListScreen()));
              }
              else{
                Fluttertoast.showToast(
                    msg: "Select at least one muscle group",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.purple.shade200,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              }, child: Text("Generate Exercise Plan"))
            ],
          ),
          ),
        // ),
      ),
    );
  }

  Widget Body() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ColorFiltered(
            colorFilter: shoulder
                ? const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  )
                : ColorFilter.matrix(grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(05, 0, 0, 0),
              child: Image.asset(
                'assets/shoulder.png',
                height: 80,
                // fit: BoxFit.scaleDown,
              ),
            ),
          ),
          ColorFiltered(
            colorFilter: chest
                ? const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  )
                : ColorFilter.matrix(grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(05, 3, 0, 0),
              child: Image.asset(
                'assets/chest.png',
                height: 65,
                width: 190,
                // fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 3, 0, 0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.,
              children: [
                ColorFiltered(
                  colorFilter: arms
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : ColorFilter.matrix(grey),
                  child: Image.asset(
                    'assets/arms_left.png',
                    height: 90,
                    // width: 80,
                    // fit: BoxFit.scaleDown,
                  ),
                ),
                ColorFiltered(
                  colorFilter: abs
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : ColorFilter.matrix(grey),
                  child: Image.asset(
                    'assets/abs.png',
                    height: 90,
                    // width: 0,
                    // fit: BoxFit.scaleDown,
                  ),
                ),
                ColorFiltered(
                  colorFilter: arms
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : ColorFilter.matrix(grey),
                  child: Image.asset(
                    'assets/arms_right.png',
                    height: 90,
                    width: 40,
                    // fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ),
          ColorFiltered(
            colorFilter: legs
                ? const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  )
                : ColorFilter.matrix(grey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
              child: Image.asset(
                'assets/legs.png',
                height: 160,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

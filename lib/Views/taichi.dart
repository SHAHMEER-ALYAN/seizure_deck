import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Taichi extends StatefulWidget {
  const Taichi({Key? key}) : super(key: key);

  @override
  State<Taichi> createState() => _Taichi();
}

class _Taichi extends State<Taichi> {

  String difficulty = "Easy";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select Difficulty",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
                labels: ["EASY", "MODERATE","HARD"],
                onToggle: (value1) {
                  if(value1==0){
                    difficulty = 'Easy';
                  }else if(value1 == 1){
                    difficulty = 'Moderate';
                  }else{
                    difficulty = 'Hard';
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
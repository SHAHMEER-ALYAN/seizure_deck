import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/yoga.dart';

class generate_exercise_plan_new extends StatefulWidget {
  const generate_exercise_plan_new({Key? key}) : super(key: key);

  @override
  State<generate_exercise_plan_new> createState() => _generate_exercise_plan();
}

class _generate_exercise_plan extends State<generate_exercise_plan_new> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("Cardio")),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {}, child: const Text("Tai Chi")),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Yoga()));
                  },
                  child: const Text("Yoga"))
            ],
          ),
        ),
      ),
    );
  }
}

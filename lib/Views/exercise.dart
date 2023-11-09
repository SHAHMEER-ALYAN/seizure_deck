import 'package:flutter/material.dart';
import 'generate_exercise_plan.dart';

class exercise extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _exerciseState();
}

class _exerciseState extends State<exercise> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(home: Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => generate_exercise_plan()));
          },child: const Text("Generate Exercise Plan"),
        ),
      ),
    ),
    );
  }
}

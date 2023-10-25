import 'package:flutter/material.dart';

class exercise extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _exerciseState();
}

class _exerciseState extends State<exercise> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Scaffold(
        body: Center(child: Text("ZINDA HO")),
      ),
    );
  }
}

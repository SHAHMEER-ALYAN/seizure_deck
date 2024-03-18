import 'package:flutter/material.dart';
import 'package:seizure_deck/services/notification_services.dart';
// import 'package:shake/shake.dart';

class Seizure extends StatefulWidget {
  const Seizure({super.key});


  @override
  _SeizureState createState() => _SeizureState();
}

class _SeizureState extends State<Seizure> {
  bool isShaking = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_android,
              size: 100,
              color: isShaking ? Colors.red : Colors.green,
            ),
            ElevatedButton(
              child: const Text('Show notifications'),
              onPressed: () {
                NotificationService()
                    .showNotification(title: 'Sample title', body: 'It works!');
              },
            ),
          ],
        )),
      ),
    );
  }
}

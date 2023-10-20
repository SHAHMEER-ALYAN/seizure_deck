import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:shake/shake.dart';

class Seizure extends StatefulWidget {

  @override
  _SeizureState createState() => _SeizureState();
}

class _SeizureState extends State<Seizure> {
  bool isShaking = false;

  @override
  void initState() {
    super.initState();



    // accelerometerEvents.listen((AccelerometerEvent event) {
    //   if (event.x.abs() > 12 || event.y.abs() > 12 || event.z.abs() > 12) {
    //     setState(() {
    //       isShaking = true;
    //     });
    //   } else {
    //     setState(() {
    //       isShaking = false;
    //     });
    //   }
    // });

    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      NotificationService().showNotification(
          title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
    }
    );
    // detector.mShakeCount = 1;
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

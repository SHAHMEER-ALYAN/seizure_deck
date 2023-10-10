import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/home.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:shake/shake.dart';
import 'package:seizure_deck/seizure.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  runApp(const MaterialApp(
    home: Login(),
  ));
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   await service.configure(iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//           onStart: onStart(), isForegroundMode: true));
//
//   service.startService();
// }

// onStart() {
//   print("********************************************");
//   ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
//     NotificationService().showNotification(
//         title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
//   } );
// }


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  // Function to handle navigation
  void _navigateToHome(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Image.asset(
                  'assets/slogo.png',
                  height: 300,
                ),
              ),
              const Text(
                "Username",
                style: TextStyle(
                    color: Color(0xFF454587),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                      hintText: "Username"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Password",
                style: TextStyle(
                    color: Color(0xFF454587),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 5, color: Color(0xFF454587)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                      hintText: "Password"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    // Call the function to handle navigation
                    // _navigateToHome(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587)),
                  child: const Text("Login")),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587)),
                  child: const Text("Create Account")),
            ],
          ),
        ),
      ),
    );
  }
}

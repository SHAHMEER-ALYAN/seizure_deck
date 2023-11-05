import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/Views/home.dart';
import 'package:seizure_deck/main.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:shake/shake.dart';
import 'package:seizure_deck/Views//seizure.dart';
import 'package:seizure_deck/Views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

late ShakeDetector checker;

void main() async {
  // Workmanager().initialize(
  //     callbackDispatcher,
  //     isInDebugMode: true);
  // Workmanager().registerOneOffTask("Seizure-Detector", "Shake-Detector");
  // WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  runApp(const MaterialApp(
    home: Login(),
  ));
}
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//           onStart: onStart,
//           isForegroundMode: false,
//           autoStart: true,
//
//           ));
// }
//
//
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   print("Background service started");
//
//   // Initialize shake detection
//   checker = ShakeDetector.autoStart(
//     onPhoneShake: () {
//
//       // Handle shake event in the background
//       print("Shake detected in the background!");
//
//       // You can add code here to show a local notification
//       NotificationService().showNotification(
//           title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
//       // showNotification();
//     },
//   );
// }

// @pragma('vm:entry-point')
// void callbackDispatcher(){
//   Workmanager().executeTask((taskName, inputData)
//   {
//     checker = ShakeDetector.autoStart(
//       onPhoneShake: () {
//
//         // Handle shake event in the background
//         print("Shake detected in the background!");
//
//         // You can add code here to show a local notification
//         NotificationService().showNotification(
//             title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
//         // showNotification();
//       },
//     );
//     return Future.value(true);
//   }
//   );
// }
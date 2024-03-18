
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/providers/exercise_provider.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/Views/login.dart';
import 'package:seizure_deck/services/SeizureDetectionModel.dart';

void main() async {
  // WidgetsBinding widgetsBinding WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await startSeizureDetection();
  // await startSeizureDetectionPred();
  // FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => ExerciseProvider()),
    ],
    child: const MaterialApp(
      home: Login(),
    ),
  ));
  }

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> startSeizureDetection() async {
  // _startListening();
  await AndroidAlarmManager.oneShot(
    const Duration(seconds: 0), // Set the interval as needed
    0,
    // SEIZURE_DETECTION_ALARM_ID,
    startListening,
    exact: true,
    wakeup: true,
    // allowWhileIdle: true,
  );
}
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> startSeizureDetectionPred() async {
  // _startListening();
  await AndroidAlarmManager.periodic(
    const Duration(minutes: 30), // Set the interval as needed
    1,
    // SEIZURE_DETECTION_ALARM_ID,
    startSeizureDetection,
    // startListening,
    exact: true,
    wakeup: true,
    // allowWhileIdle: true,
  );
}

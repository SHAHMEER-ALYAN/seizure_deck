import 'dart:async';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:seizure_deck/providers/exercise_provider.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/services/SeizureDetectionModel.dart';

import 'package:seizure_deck/Views/login.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  await startSeizureDetection();

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true,
  // );
  // Workmanager().registerPeriodicTask("SeizureDetector", task);
  // Workmanager().cancelAll();


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => ExerciseProvider()),
    ],
    child: MaterialApp(
      home: Login(),
    ),
  ));
}


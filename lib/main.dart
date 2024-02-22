
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/Views/splashss.dart';
import 'package:seizure_deck/providers/exercise_provider.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/Views/login.dart';
import 'package:seizure_deck/services/SeizureDetectionModel.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AndroidAlarmManager.initialize();
  // await startSeizureDetection();
  // await startSeizureDetectionPred();
  FlutterNativeSplash.remove();
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

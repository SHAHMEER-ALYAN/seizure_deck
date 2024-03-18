import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:direct_sms/direct_sms.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:seizure_deck/services/notification_services.dart';

const int SEIZURE_DETECTION_ALARM_ID = 0;

late tfl.Interpreter _interpreter;
late tfl.Interpreter rfInterpreter;
late tfl.Interpreter knnInterpreter;

const task = 'firstTask';
List<double> inputArray = []; // Concatenated array of 3 input arrays
List<double> inputArray2 = [];
List<double> inputArray3 = [];
List<double> array1 = [];
List<double> array2 = [];
List<double> array3 = [];

List<List<double>> output = List.filled(1, List.filled(4, 0.0));

List<List<double>> output2 = List.filled(1, List.filled(4, 0.0));
List<List<double>> output3 = List.filled(1, List.filled(4, 0.0));

int progress = 0;
String hi = "abc";
late Timer printTimer;

Future<void> _startListening() async {
  _loadModel();
  print("Seizure detection is active.");
  NotificationService().showOngoingNotification(
    title: "MONITORING MOTION",
    body: "HI READING ACCELEROMETER DATA",
  );

  // accelerometerEvents
  //     .throttleTime(const Duration(milliseconds: 50))
  //     .listen((AccelerometerEvent event) {
  // handleAccelerometerEvent(event);
  // });
  // NotificationService().showNotification(
  //   title: "MONITORING MOTION", body: "HI READING ACCELEROMETER DATA",);
  double modifyX = 1.0;
  double modifyY = 0.5;
  double modifyZ = 0.5;
  double gravity = 9.80665;
  accelerometerEvents
      .throttleTime(const Duration(
      milliseconds: 50)) // Capture around 16 values per second
      .listen((AccelerometerEvent event) {
    print('Accelerometer Event Array Length: ${array1.length}');
    // debugPrint('Accelerometer Event Array Length: ${array1.length}');
    if (event.x < 0) {
      array1.add((event.x - modifyX) / gravity);
    } else {
      array1.add((event.x + modifyX) / gravity);
    }
    if (event.y < 0) {
      // print("____________________");
      array2.add((event.y - modifyY) / gravity);
    } else {
      // print("!!!!!!!!!!!!!!!!!!!!!!!!!");
      array2.add((event.y + modifyY) / gravity);
    }
    if (event.z < 0) {
      array3.add((event.z - modifyZ) / gravity);
    } else {
      array3.add((event.z + modifyZ) / gravity);
    }

    progress = array1.length;

    if (array1.length == 206) {
      _loadModel();
      _makePrediction();

      // Clear the arrays after making the prediction
      // array1.clear();
      // array2.clear();
      // array3.clear();
      array1 = [];
      array2 = [];
      array3 = [];
      // return true;
    } else if (array1.length > 206) {
      print("Excceed Length Not good");
      array1 = [];
      array2 = [];
      array3 = [];
      // array1.clear();
      // array2.clear();
      // array3.clear();
    }
  });
}

Future<void> _makePrediction() async {
  // int? uid = UserProvider().uid;
  // Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high);

  inputArray.addAll(array1);
  inputArray.addAll(array2);
  inputArray.addAll(array3);

  inputArray2.addAll(array2);
  inputArray2.addAll(array3);
  inputArray2.addAll(array1);

  inputArray3.addAll(array3);
  inputArray3.addAll(array2);
  inputArray3.addAll(array1);

  // Reshape the input to match the expected shape [1, 4]
  List<List<double>> reshapedInput = [inputArray];

  List<List<double>> reshapedInput2 = [inputArray2];
  List<List<double>> reshapedInput3 = [inputArray3];

  // Make prediction
  List<List<double>> outputRFNEW = List.filled(1, List.filled(4, 0.0));

  List<List<double>> outputKNNNEW = List.filled(1, List.filled(4, 0.0));
  List<List<double>> outputSVMNEW = List.filled(1, List.filled(4, 0.0));

  print(array1);
  print(array2);
  print(array3);

  // _interpreter.invoke();

  _interpreter.run(reshapedInput, output);
  _interpreter.run(reshapedInput2, output2);
  _interpreter.run(reshapedInput3, output3);

  print("Prediction Output 1: ${output[0]}");

  print("Prediction Output 2: ${output2[0]}");
  print("Prediction Output 3: ${output3[0]}");
  String temp = "";
  // print(_interpreter.getOutputIndex(temp));
  // i=i+1;notification_services.dart
  output;
  output2;
  output3;

  if (output[0][0] > output[0][1] &&
      output[0][0] > output[0][2] &&
      output[0][0] > output[0][3]) {
    print("Seizure Detected!");
    // SeizureService.storeSeizureData();
    // SeizureService.storeSeizureData(uid!, DateTime.now().toString(),
    //     position.longitude.toString(), position.latitude.toString());
    _sendSms();
    _callNumber();
    NotificationService().showNotification(
        title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
  } else {
    print("No Seizure Detected Array 1.");
  }

  if (output2[0][0] > output2[0][1] &&
      output2[0][0] > output2[0][2] &&
      output2[0][0] > output2[0][3]) {
    print("Seizure Detected!");
    // SeizureService.storeSeizureData();
    // SeizureService.storeSeizureData(uid!, DateTime.now().toString(),
    //     position.longitude.toString(), position.latitude.toString());
    _sendSms();
    _callNumber();
    NotificationService().showNotification(
        title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
  } else {
    print("No Seizure Detected Array 2.");
  }

  if (output3[0][0] > output3[0][1] &&
      output3[0][0] > output3[0][2] &&
      output3[0][0] > output3[0][3]) {
    print("Seizure Detected!");
    // SeizureService.storeSeizureData();
    _sendSms();
    _callNumber();
    NotificationService().showNotification(
        title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
  } else {
    print("No Seizure Detected Array 3.");
  }

  inputArray = [];
  inputArray2 = [];
  inputArray3 = [];
  _interpreter.close();
  // rfInterpreter.close();
  // knnInterpreter.close();
  // svmInterpreter.close();
  // loadknn();
  // loadsvm();
  _loadModel();
}

_callNumber() async {
  const number = '0333123123'; //set the number here
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
}

_sendSms() async {
  const number = '0333333333';
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // final permission = Permission.sms.request();
  // if (await permission.isGranted) {
  DirectSms().sendSms(
      phone: number,
      message:
      "Latitude: ${position.latitude} Longitude: ${position.longitude}");
  // directSms.sendSms(message: message, phone: number);
}

Future<void> _loadModel() async {
  _interpreter = await tfl.Interpreter.fromAsset(
    'assets/rf_keras_model.tflite',
    options: tfl.InterpreterOptions(),
  );

  rfInterpreter = await tfl.Interpreter.fromAsset('assets/rfNEW.tflite',
      options: tfl.InterpreterOptions());
}

Future<void> startSeizureDetectionold() async {
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 0), // Set the interval as needed
    0,
    // SEIZURE_DETECTION_ALARM_ID,
    _startListening,
    exact: true,
    wakeup: true,
    // allowWhileIdle: true,
  );
}


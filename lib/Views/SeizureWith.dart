import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seizure_deck/database/seizureDB.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:direct_sms/direct_sms.dart';


class SeizureNewWith extends StatefulWidget {
  const SeizureNewWith({super.key});

  @override
  _SeizureNewWith createState() => _SeizureNewWith();
}
List<double> array1 = [];
List<double> array2 = [];
List<double> array3 = [];


class _SeizureNewWith extends State<SeizureNewWith> {

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  int? uid;
  List<double> inputArray = []; 
  List<double> inputArray2 = [];
  List<double> inputArray3 = [];

  List<List<double>> output = List.filled(1, List.filled(4, 0.0));
  List<List<double>> output2 = List.filled(1, List.filled(4, 0.0));
  List<List<double>> output3 = List.filled(1, List.filled(4, 0.0));

  int progress = 0;
  String hi = "abc";
  late Timer printTimer;

  late tfl.Interpreter _interpreter;
  late tfl.Interpreter rfInterpreter;
  late tfl.Interpreter knnInterpreter;

  late Position position;
  @override
  void initState() {
    AndroidAlarmManager.cancel(0);
    
    super.initState();
    _startListening();
    _loadModel();
    loadknn();

    printTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      print("Array1 Length: ${array1.length}");
    });
  }

  Future<void> _loadModel() async {
    
    
    _interpreter = await tfl.Interpreter.fromAsset(
      'assets/rf_keras_model.tflite',
      options: tfl.InterpreterOptions(),
    );

    rfInterpreter = await tfl.Interpreter.fromAsset('assets/rfNEW.tflite',
        options: tfl.InterpreterOptions());
  }

  Future<void> loadknn() async {
    knnInterpreter = await tfl.Interpreter.fromAsset('assets/knnNEW.tflite',
        options: tfl.InterpreterOptions());
  }

  void _startListening() {

    StreamSubscription<AccelerometerEvent> subscription;
    double modifyX = 1.0;
    double modifyY = 0.5;
    double modifyZ = 0.5;
    double gravity = 9.80665;
    Duration dd = const Duration(milliseconds: 60);
    _accelerometerSubscription = accelerometerEventStream().debounceTime(dd).listen((event) {
      setState(() {
        if (event.x < 0) {
          array1.add((event.x - modifyX) / gravity);
        } else {
          array1.add((event.x + modifyX) / gravity);
        }
        if (event.y < 0) {
          
          array2.add((event.y - modifyY) / gravity);
        } else {
          
          array2.add((event.y + modifyY) / gravity);
        }
        if (event.z < 0) {
          array3.add((event.z - modifyZ) / gravity);
        } else {
          array3.add((event.z + modifyZ) / gravity);
        }
        setState(() {
          progress = array1.length;
        });

        if (array1.length == 206) {
          _makePrediction();
          
          array1.clear();
          array2.clear();
          array3.clear();
          inputArray.clear();
          inputArray2.clear();
          inputArray3.clear();
        } else if (array1.length > 206) {
          print("Excceed Length Not good");
          array1 = [];
          array2 = [];
          array3 = [];
        }
      });
    });

  }
  // void _processAccelerometerData(List<double> data) {
  //
  //   inputArray.addAll(data);
  //
  //   if (inputArray.length == 206) {
  //
  //     _makePrediction();
  //     inputArray.clear();
  //   } else if (inputArray.length > 206) {
  //     inputArray.clear();
  //   }
  // }

  Future<void> _makePrediction() async {
    inputArray.addAll(array1);
    inputArray.addAll(array2);
    inputArray.addAll(array3);

    inputArray2.addAll(array2);
    inputArray2.addAll(array3);
    inputArray2.addAll(array1);

    inputArray3.addAll(array3);
    inputArray3.addAll(array2);
    inputArray3.addAll(array1);
    List<List<double>> reshapedInput = [inputArray];
    List<List<double>> reshapedInput2 = [inputArray2];
    List<List<double>> reshapedInput3 = [inputArray3];

    List<List<double>> outputRFNEW = List.filled(1, List.filled(4, 0.0));
    List<List<double>> outputKNNNEW = List.filled(1, List.filled(4, 0.0));
    List<List<double>> outputSVMNEW = List.filled(1, List.filled(4, 0.0));

    print(array1);
    print(array2);
    print(array3);

    _interpreter.run(reshapedInput, output);
    _interpreter.run(reshapedInput2, output2);
    _interpreter.run(reshapedInput3, output3);

    rfInterpreter.run(inputArray, outputRFNEW);
    print("Prediction of New RF: ${outputRFNEW[0]}");
    knnInterpreter.run(inputArray, outputKNNNEW);
    print("Prediction of New KNNNew: ${outputKNNNEW[0]}");
    print("Prediction Output 1: ${output[0]}");
    print("Prediction Output 2: ${output2[0]}");
    print("Prediction Output 3: ${output3[0]}");
    // String temp = "";
    setState(() {
      output;
      output2;
      output3;
    });

    if (output[0][0] > output[0][1] &&
        output[0][0] > output[0][2] &&
        output[0][0] > output[0][3]) {
      print("Seizure Detected!");
      SeizureService.storeSeizureData();
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
      SeizureService.storeSeizureData();
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
      SeizureService.storeSeizureData();
      _sendSms();
      _callNumber();
      NotificationService().showNotification(
          title: "SHAKE DETECTED", body: "You might be experiencing Seizure");
    } else {
      print("No Seizure Detected Array 3.");
    }
    array1.clear();
    array2.clear();
    array3.clear();
    print(array1.length);
    print(array2.length);
    print(array3.length);
    inputArray = [];
    inputArray2 = [];
    inputArray3 = [];
    _interpreter.close();
    rfInterpreter.close();
    knnInterpreter.close();
    loadknn();
    _loadModel();
  }
  @override
  Widget build(BuildContext context) {
    Text progressIndicator = Text("Progress: $progress");
    Text array1Prediction = Text("Array1: $output");
    Text array2Prediction = Text("Array2: $output2");
    Text array3Prediction = Text("Array3: $output3");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter TFLite Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            progressIndicator,
            const SizedBox(
              height: 15,
            ),
            array1Prediction,
            const SizedBox(
              height: 15,
            ),
            array2Prediction,
            const SizedBox(
              height: 15,
            ),
            array3Prediction,
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                print(array1.length);
              },
              child: const Text('Not Used'),
            ),
            ElevatedButton(
                onPressed: () async {
                  position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
                  NotificationService().showNotification(
                      title: "SHAKE DETECTED",
                      body: "You might be experiencing Seizure");
                  UserProvider userProvider = Provider.of(context,listen: false);
                  uid = userProvider.uid;
                  SeizureService.storeSeizureData();
                },
                child: const Text("Notification")),
          ],
        ),
      ),
    );
  }
  _callNumber() async{
    const number = '0333333333'; 
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  _sendSms() async {
    const number = '0333333333';
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      DirectSms().sendSms(phone: number, message: "Latitude: ${position.latitude} Longitude: ${position.longitude}");
  }

  @override
  void dispose() {
    _interpreter.close();
    rfInterpreter.close();
    knnInterpreter.close();
    _accelerometerSubscription?.cancel();
    printTimer.cancel();
    super.dispose();
  }

  void _accelerometerIsolate(List<double> data) {
    inputArray.addAll(data);
    if (inputArray.length == 206) {
      _makePrediction();
      inputArray.clear(); 
    } else if (inputArray.length > 206) {
      inputArray.clear(); 
    }
  }
}

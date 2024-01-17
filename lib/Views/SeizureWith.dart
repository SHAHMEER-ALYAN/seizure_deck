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
// import 'package:permission_handler/permission_handler.dart';

// import 'package:workmanager/workmanager.dart';

// import 'dart:isolate';
// import 'package:flutter_isolate/flutter_isolate.dart';

class SeizureNewWith extends StatefulWidget {
  @override
  _SeizureNewWith createState() => _SeizureNewWith();
}
List<double> array1 = [];
List<double> array2 = [];
List<double> array3 = [];


class _SeizureNewWith extends State<SeizureNewWith> {

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int? uid;

  // FlutterIsolate? _isolate;
  List<double> inputArray = []; // Concatenated array of 3 input arrays
  List<double> inputArray2 = [];
  List<double> inputArray3 = [];

  List<List<double>> output = List.filled(1, List.filled(4, 0.0));

  List<List<double>> output2 = List.filled(1, List.filled(4, 0.0));
  List<List<double>> output3 = List.filled(1, List.filled(4, 0.0));

  int progress = 0;
  String hi = "abc";
  late Timer printTimer;

  // late Isolate isolate;
  // late FlutterIsolate _isolate;

  late tfl.Interpreter _interpreter;
  late tfl.Interpreter rfInterpreter;
  late tfl.Interpreter knnInterpreter;
  // late tfl.Interpreter svmInterpreter;

  late Position position;
  @override
  void initState() {
    AndroidAlarmManager.cancel(0);
    // Workmanager().cancelAll();
    super.initState();
    _startListening();
    _loadModel();
    loadknn();
    // loadsvm();
    // _startBackgroundDetection();

    printTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      print("Array1 Length: ${array1.length}");
    });
  }

  // Future<void> _startBackgroundDetection() async {
  //   await Workmanager().initialize(callbackDispatcher);
  // }
  //
  // @pragma('vm:entry-point')
  // void callbackDispatcher() {
  //   Workmanager().registerPeriodicTask(
  //     'seizure_detection_task',
  //     'seizureDetectionTask',
  //     initialDelay: Duration(seconds: 1),
  //     frequency: Duration(seconds: 1),
  //   );
  // }

  // void seizureDetectionTask() async {
  //   // _isolate ??= await FlutterIsolate.spawn(_accelerometerIsolate, _processAccelerometerData);
  //   // ... other isolate logic
  //   _isolate ??= await FlutterIsolate.spawn((message) {_startListening();}, _processAccelerometerData);
  // }

  Future<void> _loadModel() async {
    // final interpreterOptions = tfl.InterpreterOptions()..threads = 2;
    // _interpreter = await tfl.ListShape.
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

    double modify_x = 1.0;
    double modify_y = 0.5;
    double modify_z = 0.5;
    // double modify_x = 0.0;
    // double modify_y = 0.0;
    // double modify_z = 0.0;
    double gravity = 9.80665;
    // accelerometerEvents().listen((event) { });

    // _streamSubscriptions.add(
    //     accelerometerEventStream(samplingPeriod: sensorInterval).listen(
    //             (AccelerometerEvent event) {
    Duration dd = Duration(milliseconds: 60);
    _accelerometerSubscription = accelerometerEventStream().debounceTime(dd).listen((event) {

    // });

    // _accelerometerSubscription = accelerometerEvents
    //     .debounceTime(const Duration(
    //         milliseconds: 70)) // Capture around 16 values per second
    //     .listen((AccelerometerEvent event) {
      setState(() {
        if (event.x < 0) {
          array1.add((event.x - modify_x) / gravity);
        } else {
          array1.add((event.x + modify_x) / gravity);
        }
        if (event.y < 0) {
          // print("____________________");
          array2.add((event.y - modify_y) / gravity);
        } else {
          // print("!!!!!!!!!!!!!!!!!!!!!!!!!");
          array2.add((event.y + modify_y) / gravity);
        }
        if (event.z < 0) {
          array3.add((event.z - modify_z) / gravity);
        } else {
          array3.add((event.z + modify_z) / gravity);
        }
        setState(() {
          progress = array1.length;
        });

        if (array1.length == 206) {
          _makePrediction();
          // Clear the arrays after making the prediction
          array1.clear();
          array2.clear();
          array3.clear();
          inputArray.clear();
          inputArray2.clear();
          inputArray3.clear();
          // array1 = [];
          // array2 = [];
          // array3 = [];
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
    });

  }


  void _processAccelerometerData(List<double> data) {
    // Process accelerometer data here
    inputArray.addAll(data);

    if (inputArray.length == 206) {
      // Make prediction when the array reaches the desired length
      _makePrediction();
      inputArray.clear(); // Clear the array after making the prediction
    } else if (inputArray.length > 206) {
      inputArray.clear(); // Clear the array if it exceeds the desired length
    }
  }

  Future<void> _makePrediction() async {
    // Concatenate the arrays
    // inputArray = [];

    inputArray.addAll(array1);
    inputArray.addAll(array2);
    inputArray.addAll(array3);

    inputArray2.addAll(array2);
    inputArray2.addAll(array3);
    inputArray2.addAll(array1);

    inputArray3.addAll(array3);
    inputArray3.addAll(array2);
    inputArray3.addAll(array1);

    // inputArray3.addAll(array3);
    // inputArray3.addAll(array1);
    // inputArray3.addAll(array2);

    //
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

    _interpreter.run(reshapedInput, output);
    _interpreter.run(reshapedInput2, output2);
    _interpreter.run(reshapedInput3, output3);

    rfInterpreter.run(inputArray, outputRFNEW);
    print("Prediction of New RF: ${outputRFNEW[0]}");

    // knnInterpreter.invoke();

    knnInterpreter.run(inputArray, outputKNNNEW);
    print("Prediction of New KNNNew: ${outputKNNNEW[0]}");

    // Handle the prediction output
    print("Prediction Output 1: ${output[0]}");

    print("Prediction Output 2: ${output2[0]}");
    print("Prediction Output 3: ${output3[0]}");
    String temp = "";

    setState(() {
      output;
      output2;
      output3;
    });

    if (output[0][0] > output[0][1] &&
        output[0][0] > output[0][2] &&
        output[0][0] > output[0][3]) {

      print("Seizure Detected!");
      SeizureService.storeSeizureData(uid.toString());

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
      SeizureService.storeSeizureData(uid.toString());

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
      SeizureService.storeSeizureData(uid.toString());

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
    Text progressIndicator = Text("Progress: " + progress.toString());
    Text array1Prediction = Text("Array1: " + output.toString());
    Text array2Prediction = Text("Array2: " + output2.toString());
    Text array3Prediction = Text("Array3: " + output3.toString());

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

                      // _sendSms();
                      // _callNumber();
                  UserProvider userProvider = Provider.of(context,listen: false);
                  // int? uid = userProvider.uid;
                  uid = userProvider.uid;
                  // print(uid);
                  // print(DateTime.now());
                  SeizureService.storeSeizureData(uid.toString());
                },
                child: const Text("Notification")),
          ],
        ),
      ),
    );
  }
  _callNumber() async{
    const number = '0333333333'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  _sendSms() async {
    const number = '0333333333';
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


    // final permission = Permission.sms.request();
    // if (await permission.isGranted) {
      DirectSms().sendSms(phone: number, message: "Latitude: ${position.latitude} Longitude: ${position.longitude}");
      // directSms.sendSms(message: message, phone: number);

  }

  @override
  void dispose() {
    _interpreter.close();
    rfInterpreter.close();
    knnInterpreter.close();
    _accelerometerSubscription?.cancel();
    // for (streamsubscription<dynamic> subscription in accelerometerEvents) {
    //   subscription.cancel();
    // }
    printTimer.cancel();
    // _startListening().
    super.dispose();
  }

  void _accelerometerIsolate(List<double> data) {
    // Perform accelerometer data processing in the isolate
    inputArray.addAll(data);

    if (inputArray.length == 206) {
      // Make prediction when the array reaches the desired length
      _makePrediction();
      inputArray.clear(); // Clear the array after making the prediction
    } else if (inputArray.length > 206) {
      inputArray.clear(); // Clear the array if it exceeds the desired length
    }
  }
}

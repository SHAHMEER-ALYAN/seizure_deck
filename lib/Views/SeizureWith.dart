import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:async';
// import 'dart:isolate';
import 'package:flutter_isolate/flutter_isolate.dart';



class SeizureNewWith extends StatefulWidget {
  @override
  _SeizureNewWith createState() => _SeizureNewWith();
}

class _SeizureNewWith extends State<SeizureNewWith> {
  List<double> inputArray = [];// Concatenated array of 3 input arrays
  List<double> inputArray2 = [];
  List<double> inputArray3 = [];
  List<double> array1 = [];
  List<double> array2 = [];
  List<double> array3 = [];

  List<List<double>> output = List.filled(1, List.filled(4, 0.0));

  List<List<double>> output2 = List.filled(1, List.filled(4, 0.0));
  List<List<double>> output3 = List.filled(1, List.filled(4, 0.0));

  int progress =0;
  String hi = "abc";
  late Timer printTimer;
  // late Isolate isolate;
  // late FlutterIsolate _isolate;

  late tfl.Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _startListening();
    _loadModel();

    printTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      print("Array1 Length: ${array1.length}");
    });

  }

  Future<void> _loadModel() async {
    // final interpreterOptions = tfl.InterpreterOptions()..threads = 2;
    _interpreter = await tfl.Interpreter.fromAsset(
      'assets/rf_keras_model.tflite',
      options: tfl.InterpreterOptions(),
    );
  }

  void _startListening() {
    int modify = 0;
    accelerometerEvents
        .throttleTime(const Duration(milliseconds: 50)) // Capture around 16 values per second
        .listen((AccelerometerEvent event) {
      setState(() {
        if(event.x<0){
          array1.add((event.x-modify)/ 9.80665);
        }else{
        array1.add((event.x+modify)/ 9.80665);
        }
        if(event.y < 0){
          // print("____________________");
          array2.add((event.y-modify)/ 9.80665);
        }else{
          // print("!!!!!!!!!!!!!!!!!!!!!!!!!");
        array2.add((event.y+modify)/ 9.80665);
        }
        if(event.z<0){
          array3.add((event.y-modify)/ 9.80665);
        }else{
        array3.add((event.z+modify)/ 9.80665);
        }
        setState(() {
          progress = array1.length;
        });

        if (array1.length == 206) {
          _makePrediction();
          // Clear the arrays after making the prediction
          // array1.clear();
          // array2.clear();
          // array3.clear();
          array1 = [];
          array2 = [];
          array3 = [];
        }else if(array1.length > 206){
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

  // void _startListening() {
  //   accelerometerEvents
  //       .debounceTime(const Duration(milliseconds: 50))
  //       .listen((AccelerometerEvent event) {
  //     setState(() {
  //       array1.add(event.x);
  //       array2.add(event.y);
  //       array3.add(event.z);
  //
  //       if (array1.length == 103) {
  //         // Duplicate the existing array to create a new array of 206 length
  //         array1.addAll(array1);
  //         array2.addAll(array2);
  //         array3.addAll(array3);
  //       }
  //
  //       if (array1.length >= 206) {
  //         // Take the first 206 values and make a prediction
  //         List<double> newArray1 = array1.sublist(0, 206);
  //         List<double> newArray2 = array2.sublist(0, 206);
  //         List<double> newArray3 = array3.sublist(0, 206);
  //
  //         // Make prediction with the new arrays
  //         _makePrediction(newArray1, newArray2, newArray3);
  //
  //         // Clear the arrays after making the prediction
  //         array1.removeRange(0, 206);
  //         array2.removeRange(0, 206);
  //         array3.removeRange(0, 206);
  //       }
  //     });
  //   });
  // }

  // void _startListening() {
  //   accelerometerEvents
  //       .throttleTime(const Duration(microseconds: 50))
  //       .listen((AccelerometerEvent event) {
  //     setState(() {
  //       array1.add(event.x);
  //       array2.add(event.y);
  //       array3.add(event.z);
  //
  //       if(array1.length == 206) {
  //         print("MAKING PREDICTION ARRAY");
  //         _makePrediction();
  //         array1.clear();
  //         array1.clear();
  //         array1.clear();
  //       }
  //       else if(array1.length > 206){
  //         print("CLEARING ARRAY");
  //         array1.clear();
  //         array2.clear();
  //         array3.clear();
  //       }
  //
  //       // if (array1.length == 103) {
  //       //   List<double> array1new = [];
  //       //   List<double> array2new = [];
  //       //   List<double> array3new = [];
  //       //
  //       //   array1new.addAll(array1);
  //       //   array1new.addAll(array1);
  //       //
  //       //   array2new.addAll(array2);
  //       //   array2new.addAll(array2);
  //       //
  //       //   array3new.addAll(array3);
  //       //   array3new.addAll(array3);
  //       //
  //       //   array1 = array1new;
  //       //   array2 = array2new;
  //       //   array3 = array3new;
  //       //
  //       //   // array2.addAll(array2);
  //       //   // array3.addAll(array3);
  //       //   _makePrediction();
  //       //   // Clear the arrays after making the prediction
  //       //   array1.clear();
  //       //   array2.clear();
  //       //   array3.clear();
  //       // } else if (array1.length > 103) {
  //       //   array1 = [];
  //       //   array2 = [];
  //       //   array3 = [];
  //       //   array1.clear();
  //       //   array2.clear();
  //       //   array3.clear();
  //       // }
  //     });
  //   });
  // }

  void acceFunction(){
    accelerometerEvents.throttleTime(const Duration(microseconds: 35)).listen((event) {
      array1.add(event as double);
      array2.add(event as double);
      array3.add(event as double);
      if(array1.length == 206){
        inputArray.addAll(array1);
        inputArray.addAll(array2);
        inputArray.addAll(array3);
        if(inputArray==206*3){
          _makePrediction();
          array1.clear();
          array2.clear();
          array3.clear();
        }
      }else if(array1.length > 206){
        array1.clear();
        array2.clear();
        array3.clear();
      }
    });
  }

  // void _startListening() async {
  //   // Create and start the isolate
  //   _isolate = await FlutterIsolate.spawn((message){acceFunction();}, _processAccelerometerData(inputArray));
  //   // _isolate = await FlutterIsolate.spawn(_accelerometerIsolate, onReceive: _processAccelerometerData);
  //
  //   // Listen for accelerometer events
  //   accelerometerEvents
  //       .throttleTime(const Duration(microseconds: 50))
  //       .listen((AccelerometerEvent event) {
  //         // _isolate.s
  //     _isolate.controlPort!;
  //     // _isolate.send(event);
  //   });
  // }

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

    // Reshape the input to match the expected shape [1, 4]
    List<List<double>> reshapedInput = [inputArray];

    List<List<double>> reshapedInput2 = [inputArray2];
    List<List<double>> reshapedInput3 = [inputArray3];

    // Make prediction
    // List<List<double>> output = List.filled(1, List.filled(4, 0.0));
    //
    // List<List<double>> output2 = List.filled(1, List.filled(4, 0.0));
    // List<List<double>> output3 = List.filled(1, List.filled(4, 0.0));

    print(array1);

    _interpreter.run(reshapedInput, output);
    _interpreter.run(reshapedInput2,output2);
    _interpreter.run(reshapedInput3,output3);

    // Handle the prediction output
    print("Prediction Output 1: ${output[0]}");

    print("Prediction Output 2: ${output2[0]}");
    print("Prediction Output 3: ${output3[0]}");
    String temp ="";
    // print(_interpreter.getOutputIndex(temp));
    // i=i+1;
    setState(() {
      output;
      output2;
      output3;
    });

    if (output[0][0] > output[0][1] &&
        output[0][0] > output[0][2] &&
        output[0][0] > output[0][3]) {
      print("Seizure Detected!");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Seizure Detected!'),
      //     duration: Duration(seconds: 3),
      //   ),
      // );
      NotificationService().showNotification(title: "SHAKE DETECTED",
          body: "You might be experiencing Seizure");
    } else {
      print("No Seizure Detected Array 1.");
    }

    if (output2[0][0] > output2[0][1] &&
        output2[0][0] > output2[0][2] &&
        output2[0][0] > output2[0][3]) {
      print("Seizure Detected!");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Seizure Detected!'),
      //     duration: Duration(seconds: 3),
      //   ),
      // );
      NotificationService().showNotification(title: "SHAKE DETECTED",
          body: "You might be experiencing Seizure");
      } else {
      print("No Seizure Detected Array 2.");
    }

    if (output3[0][0] > output3[0][1] &&
        output3[0][0] > output3[0][2] &&
        output3[0][0] > output3[0][3]) {
      print("Seizure Detected!");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Seizure Detected!'),
      //     duration: Duration(seconds: 3),
      //   ),
      // );
      NotificationService().showNotification(title: "SHAKE DETECTED",
          body: "You might be experiencing Seizure");
    } else {
      print("No Seizure Detected Array 3.");
    }

    inputArray = [];
    inputArray2 = [];
    inputArray3 = [];
    _interpreter.close();
    _loadModel();
  }

  // Future<void> _makePrediction(List<double> newArray1, List<double> newArray2, List<double> newArray3) async {
  //   // Concatenate the arrays
  //   List<double> newInputArray = [];
  //   newInputArray.addAll(newArray1);
  //   newInputArray.addAll(newArray2);
  //   newInputArray.addAll(newArray3);
  //
  //   // Reshape the input to match the expected shape [1, 4]
  //   List<List<double>> reshapedInput = [newInputArray];
  //
  //   // Make prediction
  //   List<List<double>> output = List.filled(1, List.filled(4, 0.0));
  //   _interpreter.run(reshapedInput, output);
  //
  //   // Handle the prediction output
  //   print("Prediction Output: ${output[0]}");
  //
  //   if (output[0][0] > output[0][1] &&
  //       output[0][0] > output[0][2] &&
  //       output[0][0] > output[0][3]) {
  //     print("Seizure Detected!");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Seizure Detected!'),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   } else {
  //     print("No Seizure Detected.");
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    // int progress =0;
    Text progressIndicator = Text("Progress: "+progress.toString());
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
            const SizedBox(height: 15,),
            array1Prediction,
            const SizedBox(height: 15,),
            array2Prediction,
            const SizedBox(height: 15,),
            array3Prediction,
            const SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () {
                print(array1.length);
              },
              child: const Text('Not Used'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.close();
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

// }



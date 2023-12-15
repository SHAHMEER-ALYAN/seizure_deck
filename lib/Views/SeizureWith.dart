import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
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
  List<double> inputArray = []; // Concatenated array of 3 input arrays
  List<double> array1 = [];
  List<double> array2 = [];
  List<double> array3 = [];
  late Timer printTimer;
  // late Isolate isolate;
  late FlutterIsolate _isolate;

  late tfl.Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _startListening();
    _loadModel();

    printTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      print("Array1 Length: ${array1.length}");
    });

  }

  Future<void> _loadModel() async {
    final interpreterOptions = tfl.InterpreterOptions()..threads = 2;
    _interpreter = await tfl.Interpreter.fromAsset(
      'assets/rf_keras_model.tflite',
      options: interpreterOptions,
    );
  }

  // void _startListening() {
  //   accelerometerEvents
  //       .debounceTime(const Duration(milliseconds: 60)) // Capture around 16 values per second
  //       .listen((AccelerometerEvent event) {
  //     setState(() {
  //       array1.add(event.x);
  //       array2.add(event.y);
  //       array3.add(event.z);
  //
  //       if (array1.length == 206) {
  //         _makePrediction();
  //         // Clear the arrays after making the prediction
  //         array1.clear();
  //         array2.clear();
  //         array3.clear();
  //       }else if(array1.length > 206){
  //         array1 = [];
  //         array2 = [];
  //         array3 = [];
  //         array1.clear();
  //         array2.clear();
  //         array3.clear();
  //       }
  //     });
  //   });
  // }

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
    accelerometerEvents.throttleTime(Duration(microseconds: 65)).listen((event) {
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

  void _startListening() async {
    // Create and start the isolate
    _isolate = await FlutterIsolate.spawn((message){acceFunction();}, _processAccelerometerData(inputArray));
    // _isolate = await FlutterIsolate.spawn(_accelerometerIsolate, onReceive: _processAccelerometerData);

    // Listen for accelerometer events
    accelerometerEvents
        .throttleTime(const Duration(microseconds: 50))
        .listen((AccelerometerEvent event) {
          // _isolate.s
      _isolate.controlPort!;
      // _isolate.send(event);
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
    inputArray = [];
    inputArray.addAll(array1);
    inputArray.addAll(array2);
    inputArray.addAll(array3);

    // Reshape the input to match the expected shape [1, 4]
    List<List<double>> reshapedInput = [inputArray];

    // Make prediction
    List<List<double>> output = List.filled(1, List.filled(4, 0.0));
    _interpreter.run(reshapedInput, output);

    // Handle the prediction output
    print("Prediction Output: ${output[0]}");

    if (output[0][0] > output[0][1] &&
        output[0][0] > output[0][2] &&
        output[0][0] > output[0][3]) {
      print("Seizure Detected!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seizure Detected!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print("No Seizure Detected.");
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TFLite Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print(array1.length);
          },
          child: Text('Not Used'),
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



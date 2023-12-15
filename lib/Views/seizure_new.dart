import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:rxdart/rxdart.dart';


class SeizureNew extends StatefulWidget {
  @override
  _SeizureNew createState() => _SeizureNew();
}

class _SeizureNew extends State<SeizureNew> {
  List<double> inputArray = []; // Concatenated array of 3 input arrays
  // late tfl.Interpreter _interpreter;
  Interpreter? interpreter;
  List<double> array1 = [];
  List<double> array2 = [];
  List<double> array3 = [];

  @override
  void initState() {
    super.initState();
    _startListening();
    loadModel();
    loadModel().then((interpreter) {
      setState(() {
        this.interpreter = interpreter;
      });
    });
  }

  Future<Interpreter> loadModel() async {
    final interpreterOptions = InterpreterOptions()
      ..threads = 2; // Spécifiez le nombre de threads souhaité pour l'interpréteur
    final interpreter = await Interpreter.fromAsset(
      'assets/rf_keras_model.tflite',
      options: interpreterOptions,
    );
    this.interpreter = interpreter;
    return interpreter;
  }

  void _startListening() {
    
    accelerometerEvents
        .throttleTime(const Duration(seconds: 13))
        .listen((AccelerometerEvent event) {
      setState(() {
        array1.add(event.x);
        array2.add(event.y);
        array3.add(event.z);
      });
    });
  }

  // void loadModel() async {
  //   // final interpreter = await tfl.Interpreter.fromAsset('assets/your_model.tflite');
  //   final interpreterOptions = InterpreterOptions()..threads = 2;
  //   // final interpreterOptions = InterpreterOptions()..threads = 2;
  //   _interpreter = await tfl.Interpreter.fromAsset('rf_keras_model.tflite',options: interpreterOptions);
  //   _interpreter.invoke();
  //   // _interpreter = await Interpreter.fromAsset('rf_keras_model.tflite', options: interpreterOptions);
  // }

  Future<bool> makePrediction() async {
    // Perform your array concatenation here before making a prediction
    // List<double> array1 = [-0.91, -0.92, -0.95, -0.95, -0.95, -0.94, -0.96, -0.96, -0.95, -0.95,
    //   -0.96, -0.96, -0.96, -0.95, -0.97, -0.95, -0.92, -0.92, -0.9, -0.9,
    //   -0.9, -0.9, -0.9, -0.9, -0.89, -0.9, -0.9, -0.9, -0.9, -0.9, -0.87,
    //   -0.9, -0.9, -0.9, -0.9, -0.9, -0.88, -0.9, -0.89, -0.9, -0.9, -0.87,
    //   -0.83, -0.86, -0.87, -0.83, -0.82, -0.84, -0.85, -0.81, -0.82, -0.8,
    //   -0.85, -0.84, -0.83, -0.8, -0.82, -0.8, -0.85, -0.85, -0.77, -0.72,
    //   -0.79, -0.81, -0.71, -0.68, -0.65, -0.63, -0.6, -0.53, -0.47, -0.43,
    //   -0.3, -0.27, -0.37, -0.47, -0.48, -0.53, -0.51, -0.53, -0.49, -0.47,
    //   -0.56, -0.58, -0.53, -0.57, -0.57, -0.56, -0.63, -0.69, -0.77, -0.75,
    //   -0.73, -0.71, -0.73, -0.72, -0.75, -0.76, -0.73, -0.75, -0.71, -0.65,
    //   -0.58, -0.54, -0.6, -0.77, -0.82, -0.77, -0.69, -0.58, -0.49, -0.46,
    //   -0.37, -0.36, -0.34, -0.27, -0.29, -0.31, -0.28, -0.28, -0.34, -0.41,
    //   -0.39, -0.39, -0.41, -0.4, -0.4, -0.4, -0.42, -0.41, -0.42, -0.44,
    //   -0.48, -0.5, -0.54, -0.51, -0.5, -0.48, -0.5, -0.53, -0.53, -0.57,
    //   -0.45, -0.52, -0.5, -0.5, -0.5, -0.53, -0.55, -0.55, -0.56, -0.58,
    //   -0.56, -0.59, -0.6, -0.62, -0.67, -0.68, -0.68, -0.68, -0.73, -0.68,
    //   -0.63, -0.68, -0.65, -0.6, -0.58, -0.58, -0.6, -0.58, -0.56, -0.58,
    //   -0.58, -0.57, -0.53, -0.52, -0.46, -0.49, -0.46, -0.48, -0.5, -0.49,
    //   -0.51, -0.48, -0.5, -0.5, -0.51, -0.63, -0.58, -0.48, -0.48, -0.48,
    //   -0.52, -0.51, -0.54, -0.46, -0.46, -0.51, -0.56, -0.58, -0.61, -0.56,
    //   -0.56, -0.47, -0.45, -0.45];

    // List<double> array2 = [-0.05, -0.02, 0.01, 0.01, -0.03, 0.04, 0.05, -0.03, 0.19, 0.42, 0.35, 0.42, 0.33,
    //   0.36, 0.32, 0.29, 0.34, 0.34, 0.32, 0.24, 0.15, 0.09, 0.02, 0.02, 0.09, 0.07,
    //   0.1, 0.06, 0.02, 0, -0.07, -0.04, -0.05, -0.05, -0.07, -0.09, -0.11, -0.11, -0.12,
    //   -0.12, -0.17, -0.22, -0.22, -0.21, -0.2, -0.19, -0.22, -0.29, -0.27, -0.28, -0.25,
    //   -0.2, -0.12, -0.1, -0.07, -0.02, -0.01, -0.04, -0.11, -0.12, -0.16, -0.15, -0.17,
    //   -0.15, -0.13, -0.03, -0.09, -0.2, -0.19, -0.15, -0.04, -0.02, -0.1, -0.15, -0.13,
    //   -0.19, -0.17, -0.19, -0.17, -0.15, -0.12, -0.18, -0.17, -0.2, -0.2, -0.19, -0.2,
    //   -0.16, -0.17, -0.22, -0.22, -0.18, -0.15, -0.11, -0.13, -0.2, -0.12, -0.05, -0.06,
    //   -0.1, -0.1, -0.07, -0.07, -0.05, -0.03, -0.17, -0.19, -0.09, -0.19, -0.15, -0.17,
    //   -0.13, -0.12, -0.12, -0.12, -0.05, -0.04, -0.04, -0.02, 0.06, 0.07, 0.07, 0.05,
    //   0.07, 0.07, 0.1, 0.12, 0.06, 0.02, 0.04, 0.1, 0.12, 0.1, 0.07, 0.1, 0.12, 0.12,
    //   0.08, 0.08, 0.03, 0.04, 0.04, 0.05, 0.02, 0.11, -0.13, -0.19, -0.24, -0.21, -0.15,
    //   -0.04, -0.18, -0.07, -0.5, -0.59, -0.49, -0.55, -0.54, -0.42, -0.48, -0.53, -0.35,
    //   -0.21, -0.37, -0.36, -0.43, -0.6, -0.53, -0.49, -0.16, -0.04, 0.15, 0.19, 0.25, 0.15,
    //   0.25, 0.22, 0.16, 0.2, 0.18, 0.27, 0.25, 0.21, 0.2, 0.25, 0.28, 0.3, 0.41, 0.33,
    //   0.4, 0.32, 0.27, 0.01, 0.1, 0.15, 0.27, 0.23, 0.38, 0.45, 0.3, 0.35, 0.58, 0.69, 0.88,
    //   0.8, 0.76];

    // List<double> array3 = [ 0.06, -1.57, -0.99, 0.23, 0.38, -1.56, -1.32, -0.25, 0.65, -0.54, -1.73, -0.81,
    //   0.34, 0.41, -1.43, -1.12, 0.01, 0.82, -0.22, -1.17, -0.46, 0.86, 0.6, -1.32, -0.63,
    //   0.35, 0.32, -1.31, -1.08, 0, 0.95, -0.05, -1.17, -0.4, 0.7, 0.38, -1.54, -0.94,
    //   0.25, 0.57, -1.07, -1.44, -0.23, 0.34, -0.45, -1.69, -0.79, 0.58, 0.07, -1.59,
    //   -0.92, 0.27, 0.57, -1.27, -1.23, -0.5, 0.88, 0, -1.3, -0.98, 0.68, 0.16, -1.78,
    //   -1.12, 0.05, 0.48, -1.51, -1.53, -0.2, 0.62, -0.23, -1.79, -0.75, 0.58, 0.13, -1.56,
    //   -1.04, 0.34, 0.1, -1.64, -1.01, -0.22, 0.76, -0.5, -1.22, -0.54, 0.73, -0.33, -1.39,
    //   -0.79, 0.41, 0.33, -1.07, -0.98, 0, 0.85, -0.55, -1.4, -0.72, 0.85, 0.32, -1.29,
    //   -0.67, 0.48, 0.78, -0.79, -1.09, 0.03, 0.65, -1.07, -1.41, -0.56, 0.78, -0.1, -1.56,
    //   -0.84, 0.7, 0.27, -1.49, -1.12, 0.26, 0.36, -1.39, -1.49, -0.42, 0.16, 0.13, -1.65,
    //   -1.3, -0.82, 0.5, 0.04, -0.96, -0.48, -0.3, -0.06, -0.02, -1.29, -0.87, -0.55, -0.69,
    //   -0.79, -0.89, -0.82, -0.8, -0.98, -0.96, -0.82, -0.68, -0.6, -0.5, -0.43, -1.14, -0.7,
    //   -0.73, -0.76, -0.89, -0.83, -0.9, -0.84, -0.84, -0.87, -0.85, -0.81, -0.77, -0.82,
    //   -0.75, -0.73, -0.7, -0.72, -0.78, -0.74, -0.75, -0.72, -0.71, -0.74, -0.72, -0.7,
    //   -0.71, -0.79, -0.8, -0.87, -0.76, -0.65, -0.57, -0.51, -0.43, -0.5, -0.57, -0.6, -0.58,
    //   -0.6, -0.57, -0.57, -0.79, -0.85, -0.85, -0.73, -0.69, -0.24, -0.44, -0.85, -0.8, -0.95,
    //   -0.83, -0.78];

    print("ARRAY SIZES ARE : ${array1.length} and ${array2.length} and ${array3.length}");

    // Concatenate the arrays
    inputArray = [];
    inputArray.addAll(array1);
    inputArray.addAll(array2);
    inputArray.addAll(array3);

    print(" array length ${inputArray.length}");

    // Make prediction
    // List<dynamic> output = await _interpreter.(inputFloat32: inputArray);

    // For ex: if input tensor shape [1,5] and type is float32
    // var input = [[1.23, 6.54, 7.81, 3.21, 2.22]];

// if output tensor shape [1,2] and type is float32
//     var output = List.filled(1*2, 0).reshape([1,4]);
    List<List<double>> myList = List.filled(1, List.filled(4, 0.0));
    List<List<double>> myListnew = List.filled(1, List.filled(1, 0.0));

    // List<dynamic> output = List.filled(1, 4);
    // List<dynamic> flattenedOutput = output.expand((list) => list).toList();
    // List<dynamic> op1=[];

    // Reshape the input to match the expected shape [1, 4]
    // List<List<double>> reshapedInput = [flattenedInput];
    // Make prediction
    // List<List<dynamic>> output = await _interpreter.run(inputArrays: reshapedInput);
    print("output length: ${myList[0].length}");
    print(array1.length);

    interpreter?.run(inputArray, myList);
// print the output

    // Handle the prediction output
    print("Prediction Output: ${myList[0]}");
    if(myList[0][0]>myList[0][1] && myList[0][0]>myList[0][2] && myList[0][0]>myList[0][3]){
      print("WORKING");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seizure Detected!'),
          duration: Duration(seconds: 3),
        ),
      );
      return true;
    }else{
      print("NOT WORKING");
      return false;
    }
  }

  @override
  void dispose() {
    interpreter?.close();
    super.dispose();
  }
  late Future<bool> seizuredetected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TFLite Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: makePrediction,
          child: Text('Make Prediction'),
        ),
      ),
    );
  }
}
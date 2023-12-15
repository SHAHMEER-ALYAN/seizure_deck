// prediction_model.dart
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionModel {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    final interpreterOptions = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset('assets/rf_keras_model.tflite', options: interpreterOptions);
  }

  Float32List prepareInputData(List<double> xData, List<double> yData, List<double> zData) {
    // Concatenate the three arrays
    List<double> inputData = [];
    inputData.addAll(xData);
    inputData.addAll(yData);
    inputData.addAll(zData);
    return Float32List.fromList(inputData);
  }

  List<double> predict(List<double> xData, List<double> yData, List<double> zData) {
    final inputData = prepareInputData(xData, yData, zData);
    final outputData = List<double>.from(_interpreter.getOutputTensor(0).data);

    _interpreter.run([inputData],outputData);

    return outputData;
  }
}

import 'dart:typed_data';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class SeizureDetectionModel {
  Interpreter? interpreter;

  SeizureDetectionModel() {
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/rf_keras_model.tflite');
  }

  Future<int> predict(List<double> accelerometerData) async {
    if (interpreter == null) {
      throw Exception('Model not loaded');
    }

    // Perform any necessary pre-processing on the accelerometer data
    // ...

    // Run inference
    final input = Float32List.fromList(accelerometerData);
    final output = List<List<double>>.generate(1, (index) => List<double>.filled(1, 0));

    interpreter!.run(input, output);

    // Perform any necessary post-processing on the inference result
    // ...

    return output[0][0].round();
  }
}

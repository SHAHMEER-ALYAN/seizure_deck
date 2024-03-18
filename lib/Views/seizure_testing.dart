import 'package:flutter/material.dart';


class SeizureTest extends StatefulWidget {
  const SeizureTest({super.key});

  @override
  _SeizureTestState createState() => _SeizureTestState();
}

class _SeizureTestState extends State<SeizureTest> {
  // SeizureDetectionModel model = SeizureDetectionModel();

  @override
  void initState() {
    super.initState();
    // Call a function to simulate accelerometer data
    // simulateAccelerometerData();
  }

  // void simulateAccelerometerData() {
  //   // Parse your test data here and loop through each record
  //   // List<List<double>> testData = parseTestData(); // You need to implement parseTestData()
  //
  //   for (List<double> accelerometerData in testData) {
  //     // Use the model to predict seizures
  //     final prediction = model.predict(accelerometerData);
  //
  //     // Handle the prediction (e.g., update UI, trigger an alert, etc.)
  //     handlePrediction(prediction as int);
  //   }
  // }

  // List<List<double>> parseTestData() {
  //   // Paste your test data here
  //   String testData = '
  //   0.6 0.6 0.6 0.61 0.59 0.59 0.59 0.6 0.6 0.6 0.59 0.58 0.56 0.53 0.53 0.54 0.56 0.56 0.53 0.54 0.51 0.47 0.46 0.49 0.48 0.49 0.5 0.51 0.49 0.49 0.48 0.44 0.46 0.45 0.46 0.47 0.48 0.48 0.48 0.48 0.42 0.38 0.37 0.28 0.24 0.24 0.19 0.12 0.12 0.07 0.06 0.01 -0.09 -0.1 -0.12 -0.17 -0.18 -0.19 -0.19 -0.17 -0.18 -0.24 -0.23 -0.2 -0.21 -0.21 -0.2 -0.23 -0.25 -0.24 -0.25 -0.27 -0.27 -0.24 -0.33 -0.29 -0.29 -0.32 -0.29 -0.26 -0.19 -0.19 -0.16 -0.15 -0.1 -0.06 -0.09 -0.06 -0.04 -0.07 -0.21 0.07 0.11 0.02 0.01 0.12 0.12 0.09 0.03 0.02 -0.04 -0.04 -0.03 0 0 0.01 0 -0.02 -0.01 0 0 -0.01 -0.07 0 -0.11 -0.18 -0.13 -0.12 -0.12 -0.13 -0.11 -0.09 -0.18 -0.18 -0.2 -0.21 -0.21 -0.19 -0.21 -0.25 -0.34 -0.35 -0.36 -0.34 -0.34 -0.36 -0.38 -0.39 -0.38 -0.39 -0.41 -0.45 -0.47 -0.48 -0.51 -0.52 -0.52 -0.52 -0.52 -0.51 -0.51 -0.52 -0.52 -0.52 -0.52 -0.51 -0.5 -0.49 -0.5 -0.54 -0.58 -0.61 -0.63 -0.66 -0.67 -0.68 -0.69 -0.68 -0.69 -0.69 -0.68 -0.68 -0.67 -0.68 -0.68 -0.68 -0.68 -0.68 -0.69 -0.7 -0.69 -0.7 -0.7 -0.7 -0.72 -0.7 -0.69 -0.73 -0.77 -0.77 -0.71 -0.72 -0.71 -0.73 -0.74 -0.75 -0.77 -0.75 -0.7 -0.68 -0.69 -0.7 -0.7 -0.69 -0.7 -0.7
  //   -1.72 -1.28 1.49 0.78 -0.71 -1.62 1.17 1.17 0.2 -1.88 -1.29 1.66 0.89 -0.19 -1.79 0.34 1.22 0.55 -1.25 -1.65 1.37 0.93 -0.25 -1.79 0.17 1.38 0.46 -1.42 -1.6 1.36 0.98 -0.35 -1.79 0.27 0.92 0.5 -1.35 -1.32 1.56 1.08 -0.1 -1.85 0.07 1.24 0.47 -1.43 -1.58 1.49 1.05 -0.63 -1.66 1.34 1.16 -0.09 -1.58 -0.14 1.63 0.83 -1.39 -0.94 2.07 1.34 0.25 -1.69 1.34 1.48 0.28 -1.79 0.02 1.89 0.98 -1.65 -1.34 1.7 1.33 -0.27 -1.84 0.14 1.38 0.56 -1.32 -0.38 1.31 0.56 -1.09 -1.54 1.54 1.03 -0.17 -1.77 0.02 1.5 0.49 -1.49 -1.52 1.51 0.99 -0.42 -1.61 1.36 1.44 0.31 -1.46 -0.27 1.56 0.64 -1.13 -1.19
  //   '}

  void handlePrediction(int prediction) {
    // Your logic to handle the prediction (e.g., update UI, trigger an alert, etc.)
    print('Seizure prediction: $prediction');

    if (prediction == 1) {
      // Seizure detected, show a notification
      showNotification();
    }
  }

  Future<void> showNotification() async {
    // Your notification code remains the same
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seizure Detection Test'),
      ),
      body: const Center(
        child: Text('Simulating accelerometer data for testing...'),
      ),
    );
  }
}

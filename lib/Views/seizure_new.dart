import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../services/SeizureDetectionModel.dart';

class SeizureNew extends StatefulWidget {
  @override
  _SeizureNewState createState() => _SeizureNewState();
}

class _SeizureNewState extends State<SeizureNew> {
  SeizureDetectionModel model = SeizureDetectionModel();
  late List<List<double>> accelerometerDataList;
  late AccelerometerEvent latestEvent;

  @override
  void initState() {
    super.initState();
    accelerometerDataList = [];
    listenToAccelerometer();
  }

  void listenToAccelerometer() {
    accelerometerEvents
        .throttleTime(const Duration(milliseconds: 500))
        .listen((AccelerometerEvent event) {
      setState(() {
        latestEvent = event;
        accelerometerDataList.add([event.x, event.y, event.z]);
      });

      // Use the model to predict seizures
      final prediction = model.predict([event.x, event.y, event.z]);

      // Handle the prediction (e.g., update UI, trigger an alert, etc.)
      handlePrediction(prediction);
    });
  }

  void handlePrediction(Future<int> prediction) async {
    // Your logic to handle the prediction (e.g., update UI, trigger an alert, etc.)
    final result = await prediction;
    print('Seizure prediction: $result');

    // You can add your UI update logic here based on the prediction result
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seizure Detection App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (latestEvent != null)
            Text(
              'Accelerometer Values: X=${latestEvent.x}, Y=${latestEvent.y}, Z=${latestEvent.z}',
              style: TextStyle(fontSize: 18),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              accelerometerDataList.clear();
            },
            child: Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

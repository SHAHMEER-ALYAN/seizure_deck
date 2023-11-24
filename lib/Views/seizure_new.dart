import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../services/SeizureDetectionModel.dart';


class seizureNew extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<seizureNew> {
  SeizureDetectionModel model = SeizureDetectionModel();
  late BehaviorSubject<AccelerometerEvent> accelerometerEvents;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    accelerometerEvents = BehaviorSubject<AccelerometerEvent>();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Initialize the plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    listenToAccelerometer();
  }

  void listenToAccelerometer() {
    accelerometerEvents
        .debounceTime(const Duration(milliseconds: 500))
        .listen((AccelerometerEvent event) {
      final accelerometerData = [event.x, event.y, event.z];

      // Use the model to predict seizures
      final prediction = model.predict(accelerometerData);

      // Handle the prediction (e.g., update UI, trigger an alert, etc.)
      handlePrediction(prediction);
    });

    accelerometerEvents.addStream(accelerometerEvents.throttleTime(Duration(milliseconds: 500)));
  }

  void handlePrediction(Future<int> prediction) async {
    // Your logic to handle the prediction (e.g., update UI, trigger an alert, etc.)
    final result = await prediction;
    print('Seizure prediction: $result');

    if (result == 1) {
      // Seizure detected, show a notification
      await showNotification();
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Seizure Detected',
      'A seizure has been detected.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seizure Detection App'),
      ),
      body: Center(
        child: Text('Listening to accelerometer data...'),
      ),
    );
  }

  @override
  void dispose() {
    accelerometerEvents.close();
    super.dispose();
  }
}
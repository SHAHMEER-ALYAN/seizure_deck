import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:seizure_deck/services/SeizureDetectionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingscreen extends StatefulWidget {
  const settingscreen({super.key});

  @override
  State<settingscreen> createState() => _settingscreen();
}

class _settingscreen extends State<settingscreen> {
  TextEditingController numberSaver = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: numberSaver,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "PHONE NUMBER"),
                ),
              ),
              // const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    print(numberSaver.text);
                    prefs.setString('number', numberSaver.text);
                  },
                  child: const Text("Set Emergency Number")),
              SizedBox(
                height: 20,
              ),
              // ElevatedButton(
              //     onPressed: () async {
              //       AndroidAlarmManager.cancel(0);
              //       AndroidAlarmManager.cancel(1);
              //     },
              //     child: const Text("Stop Detection Service"))
            ],
          ),
        ),
      ),
    );
  }
}

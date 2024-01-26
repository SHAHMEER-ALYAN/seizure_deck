import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/Community.dart';

import 'package:seizure_deck/Views/exercise.dart';
import 'package:seizure_deck/Views/login.dart';
import 'package:seizure_deck/Views/medicationHomepage.dart';
import 'package:seizure_deck/Views/seizureList.dart';
import 'package:seizure_deck/Views/settingsScreen.dart';
import 'package:seizure_deck/data/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SeizureWith.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double buttonWidth = 175.0;
  double buttonHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      await pref.remove('RememberMe');
                      await pref.clear();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text('Logout')),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    SizedBox seizureDiaryButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () async {
            await AndroidAlarmManager.cancel(0);
            print(" yo yo ${AndroidAlarmManager.channelName}");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SeizureList()));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const SeizureNewWith()));
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book, size: 40, color: Color(0xFF00C8DD)),
              SizedBox(height: 5),
              Text("Seizure Diary")
            ],
          ),
        ),
      );
    }

    SizedBox medicationButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const medicationHomePage()));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medication, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text("Medication")
              ],
            )),
      );
    }

    SizedBox exerciseButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const exercise()));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text(
                  "Exercise",
                )
              ],
            )),
      );
    }

    SizedBox communityButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DiscussionScreen()));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text("Community")
              ],
            )),
      );
    }

    SizedBox popularHospitalButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight + 5,
        child: ElevatedButton(
            onPressed: () {},
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_hospital, size: 40, color: Color(0xFF00C8DD)),
                SizedBox(height: 5),
                Text(
                  "Popular Hospitals",
                  textAlign: TextAlign.center,
                )
              ],
            )),
      );
    }

    SizedBox firstAidButton() {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight + 5,
        child: ElevatedButton(
            onPressed: () {},
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_information,
                  size: 40,
                  color: Color(0xFF00C8DD),
                ),
                SizedBox(height: 5),
                Text(
                  "First Aid Instructions",
                  textAlign: TextAlign.center,
                )
              ],
            )),
      );
    }

    return MaterialApp(
      theme: ThemeManager.lightTheme,
      home: WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF454587),
            centerTitle: true,
            title: const Text(
              "Homepage",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("DOING SOMETHING");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const settingscreen()));
                },
              )
            ],
          ),
          body: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/slogo.png',
                    height: 170,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    seizureDiaryButton(),
                    medicationButton(),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [exerciseButton(), communityButton()],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [popularHospitalButton(), firstAidButton()],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

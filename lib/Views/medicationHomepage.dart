import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/medication_reminder.dart';

class medicationHomePage extends StatelessWidget {
  const medicationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remove app bar for this page
        title: const Text('Medication Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Your app logo
            Image.asset(
              'assets/LOGO.png',
              height: 175,
            ),
            const Text(
              'Press + to add a Reminder!',
              style: TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 81, 81, 82)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const medicationReminder()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

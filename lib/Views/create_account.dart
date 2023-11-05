import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:seizure_deck/database/create.dart';

class create_account extends StatefulWidget {
  const create_account({super.key});

  @override
  State<create_account> createState() => _create_accountState();
}


class _create_accountState extends State<create_account> {

  DateTime selectedDate = DateTime.now(); // Initialize with the current date

  late TextEditingController name;

  // name.text = "";

  late TextEditingController password;

  late TextEditingController DOB;

  late TextEditingController email;

  late TextEditingController location;

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    location = TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900), // Adjust the range as needed
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  ButtonStyle customElevatedButtonStyle = ElevatedButton.styleFrom(
    primary: const Color(0xFF454587), // Background color
    onPrimary: Colors.white, // Text color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: const BorderSide(width: 5, color: Color(0xFF454587)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // `UID`, `Name`, `Password`, `DOB`, `Email`, `Location`, `PID`
                const Text(
                  "Enter Name",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 5, color: Color(0xFF454587)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                        hintText: "Name"),
                  ),
                ),
              const SizedBox(height: 20,),
                const Text(
                  "Enter Password",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: password,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 5, color: Color(0xFF454587)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                        hintText: "Password"),
                  ),
                ),
              SizedBox(height: 20,),
                const Text(
                  "Enter Date of Birth",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      _selectDate(context);

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF454587)),
                    child: const Text("Date of Birth")),
                SizedBox(height: 20,),
                const Text(
                  "Enter Email",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 5, color: Color(0xFF454587)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                        hintText: "Email"),
                  ),
                ),
                SizedBox(height: 20,),
                const Text(
                  "Enter Location",
                  style: TextStyle(
                      color: Color(0xFF454587),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: location,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 5, color: Color(0xFF454587)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 5, color: Color(0xFF454587))),
                        hintText: "Location"),
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: () {
                      print(location.text);
                      print("${selectedDate.toLocal()}".split(' ')[0]);
                      print(name.text);
                      print(password.text);
                      print(email.text);
                      addUserToDatabase(
                          name, password, selectedDate, email, location);
                      // addUserToDatabase();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF454587)),
                    child: const Text("Create Account")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// Future<void> addUserToDatabase() async {
//   const url = 'https://seizure-deck.000webhostapp.com/create.php'; // Replace with your server URL
//
//   final httpClient = HttpClient()..badCertificateCallback = (cert, host, port) => true;
//
//   final ioClient = IOClient(httpClient);
//
//   final response = await ioClient.post(
//     Uri.parse(url),
//     body: {
//       'Name': name.text,
//       'Password': password.text,
//       'DOB': "${selectedDate.toLocal()}".split(' ')[0], // Format the date
//       'Email': email.text,
//       'Location': location.text,
//     },
//   );
//
//   if (response.statusCode == 200) {
//     print("User added successfully!");
//   } else {
//     print("Failed to add user. Status code: ${response.statusCode}");
//   }
// }
}

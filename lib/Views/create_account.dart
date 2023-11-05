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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // `UID`, `Name`, `Password`, `DOB`, `Email`, `Location`, `PID`
              Text("Enter Name"),
              TextField(
                controller: name,
                decoration: InputDecoration(hintText: "Name"),
              ),
              Text("Enter Password"),
              TextField(
                controller: password,
                decoration: InputDecoration(hintText: "Password"),
              ),
              Text("Enter Date of Birth"),
              ElevatedButton(onPressed: () {
                _selectDate(context);
              } , child: Text("Date of Birth")),
              Text("Enter Email"),
              TextField(
                controller: email,
                decoration: InputDecoration(hintText: "Email"),
              ),
              Text("Enter Location"),
              TextField(
                controller: location,
                decoration: InputDecoration(hintText: "Location"),
              ),
              ElevatedButton(onPressed: () {
                print(location.text);
                print("${selectedDate.toLocal()}".split(' ')[0]);
                print(name.text);
                print(password.text);
                print(email.text);
                addUserToDatabase(name, password, selectedDate, email, location);
                // addUserToDatabase();
              }, child: const Text("Create Account"))

            ],
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


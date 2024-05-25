import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/io_client.dart';

Future<void> addUserToDatabase(
    TextEditingController name,
    TextEditingController password,
    DateTime selectedDate,
    TextEditingController email,
    TextEditingController location) async {
  const url =
      'https://seizuredeck.000webhostapp.com/create.php'; // Replace with your server URL

  final httpClient = HttpClient()
    ..badCertificateCallback = (cert, host, port) => true;

  final ioClient = IOClient(httpClient);

  final response = await ioClient.post(
    Uri.parse(url),
    body: {
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'dob': "${selectedDate.toLocal()}".split(' ')[0], // Format the date
      'location': location.text,
    },
  );

  if (response.statusCode == 200) {
    print("User added successfully!");
  } else {
    print("Failed to add user. Status code: ${response.statusCode}");
  }
}

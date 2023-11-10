import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<int?> loginDBCheck(TextEditingController email,TextEditingController password) async {
  bool check;
  const url = 'https://seizure-deck.000webhostapp.com/login.php'; // Replace with your server URL

  final response = await http.post(
    Uri.parse(url),
    body: {
      'email': email.text,
      'password': password.text,
    },
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body); // Parse the JSON response

    if (responseBody['message'] == "Login successful") {
      // Successful login
      print("Login successful");
      return (responseBody['uid']);
    } else if (responseBody['message'] == "Wrong password") {
      // Wrong password
      print("Wrong password");
      return null;
    } else if (responseBody['message'] == "Email not found") {
      // Email not found
      print("Email not found");
      return null;
    } else {
      // Handle other responses if needed
      print("Unexpected response: ${response.body}");
      return null;
    }
  } else {
    // Handle connection or server errors
    print("Failed to connect to the server");
    return null;
  }
}
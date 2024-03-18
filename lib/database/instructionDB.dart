import 'dart:convert';

import 'package:seizure_deck/data/instructions.dart';
import 'package:http/http.dart' as http;

Future<List<Instructions>> fetchLinks() async {
  try {
    final response = await http.get(
        Uri.parse('https://seizuredeck.000webhostapp.com/instructions.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((data) => Instructions.fromJson(data)).toList();

      // setState(() {
      //   resourceLinks =
      //       data.map((item) => item['resource']).toList().cast<String>();
      // });
    }else{
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
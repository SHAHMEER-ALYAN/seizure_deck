import 'package:flutter/foundation.dart';

class Instructions {
  final int inid;
  final String title;
  final String url;

  Instructions({
    required this.inid,
    required this.title,
    required this.url
  });

  factory Instructions.fromJson(Map<String, dynamic> json){
    return Instructions(
        inid: int.parse(json['inid']),
        title: json['title'],
        url: json['resource']);
  }

}


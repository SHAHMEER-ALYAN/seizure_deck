import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webpage extends StatefulWidget {
  String url;

  webpage({super.key, required this.url});

  @override
  State<webpage> createState() => _webpage(url);
}

class _webpage extends State<webpage> {
  String link;
  _webpage(this.link);
  // Uri url = Uri.parse(link);


  @override
  Widget build(BuildContext context) {
    link = widget.url;
    Uri url = Uri.parse(link);
    WebViewController controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(url);
    return MaterialApp(
      home: Scaffold(
        body: WebViewWidget(
            controller: controller),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<String> resourceLinks = [];

  Future<void> fetchLinks() async {
    try {
      final response = await http.get(
          Uri.parse('https://seizuredeck.000webhostapp.com/instructions.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          resourceLinks =
              data.map((item) => item['resource']).toList().cast<String>();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF454587),
        centerTitle: true,
        title: const Text("Instruction List"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).primaryColor,
            )),
      ),
      body: Center(
        child: resourceLinks.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: resourceLinks.length,
                itemBuilder: (BuildContext context, int index) {
                  String link = resourceLinks[index];
                    Uri url = Uri.parse(link);
                    return
                      Card(
                        elevation: 40,
                          shadowColor: Color(0xFF454587),
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: YoutubePlayer.convertUrlToId(link) ?? '',
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blueAccent,
                          aspectRatio: 16 / 9,
                        ),
                      )

                      );
                },
              ),
      ),
    );
  }
}

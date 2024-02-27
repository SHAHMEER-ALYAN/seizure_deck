import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seizure_deck/Views/login.dart';
import 'package:seizure_deck/Views/webpage.dart';
import 'package:seizure_deck/data/instructions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../database/instructionDB.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Instructions> resourceLinks = [];

  @override
  void initState() {
    super.initState();
    // fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF454587),
        centerTitle: true,
        title: const Text("Instruction List",style: TextStyle(color: Colors.white),),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme
                  .of(context)
                  .primaryColor,
            )),
      ),
      body: Center(
          child: FirstAidList()),
    );
  }
// ListView.builder(
//         itemCount: resourceLinks.length,
//         itemBuilder: (BuildContext context, int index) {
//           String link = resourceLinks[index];
//             Uri url = Uri.parse(link);
//             return
//               Card(
//                 elevation: 40,
//                   shadowColor: Color(0xFF454587),
//                   child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: YoutubePlayer(
//                   controller: YoutubePlayerController(
//                     initialVideoId: YoutubePlayer.convertUrlToId(link) ?? '',
//                     flags: const YoutubePlayerFlags(
//                       autoPlay: false,
//                       mute: false,
//                     ),
//                   ),
//                   showVideoProgressIndicator: true,
//                   progressIndicatorColor: Colors.blueAccent,
//                   aspectRatio: 16 / 9,
//                 ),
//               )
//
//               );
//         },
//       ),
}

Widget FirstAidList() {
  return FutureBuilder(
    future: fetchLinks(),
    builder:
        (BuildContext context, AsyncSnapshot<List<Instructions>> snapshot) {
      List<Instructions> instData = snapshot.data!;
      return ListBuild(context, instData);
    },
  );
}

Widget ListBuild(BuildContext context, List<Instructions> userInstruction) {
  return ListView.builder(
      itemCount: userInstruction.length,
      itemBuilder: (context, index) {
        Instructions inst = userInstruction[index];
        return InstructionsListTile(context, inst);
      });
}

Widget InstructionsListTile(BuildContext context, Instructions inst) {
  if (inst.url.contains("youtube")) {
    return Card(
      elevation: 40,
      shadowColor: Color(0xFF454587),
      child: Column(
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(inst.url) ?? '',
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            ),
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            aspectRatio: 16 / 9,
          ),
          Text(inst.title, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),)
        ],
      ),
    );
  } else {
    WebViewController controller;
    Uri url = Uri.parse(inst.url);
    controller = WebViewController()
      ..loadRequest(url);
    return GestureDetector(
        child: Card(
          elevation: 40,
          shadowColor: Color(0xFF454587),
          child: Container(
            height: 50,
            child: Center(
              child: Text(inst.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,color: Colors.blue,
                  decoration: TextDecoration.underline,),),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => webpage(url: inst.url)));
        });
  }
}

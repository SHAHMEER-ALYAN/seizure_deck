import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/data/exercise_data.dart';
import 'package:seizure_deck/database/save_exerciseDB.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../database/exercise_listDB.dart';

class exerciseList extends StatefulWidget {
  exerciseList({Key? key}) : super(key: key);

  @override
  State<exerciseList> createState() => _exerciseList();
}

class _exerciseList extends State<exerciseList> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        'https://www.example.com/sample-video.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: false);
    int? uid = userProvider.uid;

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<Exercise>>(
          future: ExerciseService.getExercisesForUser(uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No exercises found for the user'));
            } else {
              List<Exercise> userExercises = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Exercise List",
                    style: TextStyle(
                        color: Color(0xFF454587),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: ListView.builder(
                      itemCount: userExercises.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = userExercises[index];
                        return Center(
                          child: ListTile(
                            title: Center(
                                child: Text('Exercise Name: ${exercise.eName}')),
                            subtitle: Column(
                              children: [
                                exercise.link.isEmpty
                                    ? const Text("No Video")
                                    : YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId: YoutubePlayer.convertUrlToId(
                                        exercise.link) ??
                                        '',
                                    flags: const YoutubePlayerFlags(
                                      autoPlay: false,
                                      mute: false,
                                    ),
                                  ),
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.blueAccent,
                                ),
                                Text(
                                  'Exercise ID: ${exercise.eid} \n'
                                      'Time Required: ${exercise.time} minutes\n',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < userExercises.length; i++) {
                        addToExercisePlan(userProvider.uid, userExercises[i].eid);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587),
                    ),
                    child: const Text(
                      "Upload Exercise Plan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

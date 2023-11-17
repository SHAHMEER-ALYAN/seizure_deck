import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/data/count_Data.dart';
import 'package:seizure_deck/providers/exercise_provider.dart';
import 'package:seizure_deck/Views/generate_exercise_plan.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../data/exercise_data.dart';
import '../database/save_exerciseDB.dart';
import '../providers/user_provider.dart';


class exerciseList extends StatefulWidget {
  const exerciseList({Key? key}) : super(key: key);

  @override
  State<exerciseList> createState() => _exerciseList();
}

class _exerciseList extends State<exerciseList> {

  List<int> selectedExerciseIds = [];
  // List<int> selectedExerciseIds = [];
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        'https://www.example.com/sample-video.mp4');
    late VideoPlayerController _controller123;
// Replace with actual video URL
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
    ExerciseProvider exerciseProvider = Provider.of<ExerciseProvider>(context);

    UserProvider userProvider = Provider.of<UserProvider>(
        context, listen: false);
    // print(exerciseProvider.exercises);

    return MaterialApp(
        home: Scaffold(
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Exercise List",style: TextStyle(
              color: Color(0xFF454587),
              fontWeight: FontWeight.bold,
              fontSize: 20)),
        SizedBox(
          height: MediaQuery.of(context).size.height/1.3,
          child: ListView.builder(
          itemCount: exerciseProvider.exercises.length,
          itemBuilder: (context, index)
    {
      Exercise exercise = exerciseProvider.exercises[index];
      bool isSelected = selectedExerciseIds.contains(exercise.eid);
      return Center(
          child: ListTile(
              title: Center(child: Text('Exercise Name: ${exercise.eName}')),
              subtitle:
              Column(
                children: [
                  exercise.link.isEmpty
                      ? const Text("No Video")
                      : YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId:
                      YoutubePlayer.convertUrlToId(exercise.link) ??
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
              // Text('Exercise ID: ${exercise.eid} \n'
              //         'Time Required: ${exercise.time} minutes\n'),
            trailing: IconButton(
              icon: isSelected
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
              onPressed: () {
                setState(() {
                  if (isSelected) {
                    selectedExerciseIds.remove(exercise.eid);
                    print(selectedExerciseIds);
                  } else {
                    selectedExerciseIds.add(exercise.eid as int);
                    print(selectedExerciseIds);
                  }
                });
              },
            ),
          ),
      );
    },
          ),
        ),

    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () {
    for (int i = 0; i < exerciseProvider.exercises.length; i++) {
    addToExercisePlan(userProvider.uid, exerciseProvider.exercises[i].eid);
    }
    },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF454587)),
    child: Text("Upload Exercise Plan"),
    ),
    ],
    ),
    ),
    );
    }
  }

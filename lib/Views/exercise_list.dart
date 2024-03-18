import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/data/exercise_data.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../database/exercise_listDB.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF454587),
          centerTitle: true,
          title: const Text("Exercise List",style: TextStyle(color: Colors.white),),
        ),
        body: _buildExerciseList(context),
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: false);
    return FutureBuilder<List<Exercise>>(
      future: ExerciseService.getExercisesForUser(userProvider.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No exercises found for the user'));
        } else {
          List<Exercise> userExercises = snapshot.data!;
          return _buildExerciseListView(context, userExercises);
        }
      },
    );
  }

  Widget _buildExerciseListView(BuildContext context, List<Exercise> userExercises) {
    UserProvider userProvider = Provider.of(context,listen: false);
    int? uid = userProvider.uid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child:
          ListView.builder(
            itemCount: userExercises.length,
            itemBuilder: (context, index) {
              Exercise exercise = userExercises[index];
              return _buildExerciseTile(context, exercise);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseTile(BuildContext context, Exercise exercise) {
    return Center(
      child: ListTile(
        title: Center(child: Text('Exercise Name: ${exercise.eName}',
          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
        subtitle: Column(
          children: [
            _buildExerciseVideo(exercise.link),
            Text(
              'Exercise ID: ${exercise.eid} \n'
                  'Time Required: ${exercise.time} minutes\n',
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseVideo(String link) {
    return link.isEmpty
        ? const Text("No Video")
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
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
        );
  }
}
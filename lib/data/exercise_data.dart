class Exercise {
  final int eid;
  final String eName;
  final String type;
  final String difficulty;
  final int time;
  final String link;

  Exercise({
    required this.eid,
    required this.eName,
    required this.type,
    required this.difficulty,
    required this.time,
    required this.link,
  });
  // "eid":1,"e_name":"Marching in
  // Place","Type":"Cardio","difficulty":"Easy","time":2

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      eid: int.parse(json['eid']),
      eName: json['eName'],
      type: json['type'],
      difficulty: json['difficulty'],
      time: int.parse(json['time']),
      link: json['link']
    );
  }
}

class ExerciseList {
  final List<Exercise> exercises;

  ExerciseList({required this.exercises});

  factory ExerciseList.fromJson(List<dynamic> json) {
    return ExerciseList(
      exercises: json.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList(),
    );
  }
}


class Exercise {
  final String eid;
  final String eName;
  final String difficulty;
  final String timeRequired;
  final String spaceRequired;
  final String equipment;

  Exercise({
    required this.eid,
    required this.eName,
    required this.difficulty,
    required this.timeRequired,
    required this.spaceRequired,
    required this.equipment,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      eid: json['eid'],
      eName: json['e_name'],
      difficulty: json['difficulty'],
      timeRequired: json['time_required'],
      spaceRequired: json['space_required'],
      equipment: json['equipment'],
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

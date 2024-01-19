class Comment {
  final String uid;
  final String name;
  final String comment;
  final String datetime;

  Comment({required this.uid, required this.name, required this.comment, required this.datetime});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      uid: json['uid'],
      name: json['name'],
      comment: json['comment'],
      datetime: json['datetime'],
    );
  }
}
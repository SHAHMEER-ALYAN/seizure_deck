class SeizureDetection {
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String userName;

  SeizureDetection({
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.userName,
  });

  factory SeizureDetection.fromJson(Map<String, dynamic> json) {
    return SeizureDetection(
      dateTime: DateTime.parse(json['date']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      userName: json['name'],
    );
    // [{"date":"2024-01-06 03:37:33","latitude":"67.8","longitude":"24.6","name":"TestUser123"},{"date":"2024-01-06

  }
}
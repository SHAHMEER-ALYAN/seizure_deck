class Hospital {
  final String formattedAddress;
  final Map<String, dynamic> location;
  final Map<String, dynamic> displayName;
  final String rating;

  Hospital({
    required this.formattedAddress,
    required this.location,
    required this.displayName,
    required this.rating,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      formattedAddress: json['formattedAddress'],
      location: json['location'],
      displayName: json['displayName'],
      rating: json['rating'].toString(),
    );
  }
}

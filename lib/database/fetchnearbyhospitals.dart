// import 'package:http/http.dart' as http;

// Future<void> fetchNearbyHospitals() async {
//   final apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
//   final radius = 5000; // Specify the radius in meters
//
//   final url =
//       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.latitude},${widget.longitude}&radius=$radius&type=hospital&key=$apiKey';
//
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     // setState(() {
//     //   hospitals = json.decode(response.body)['results'];
//     // });
//   } else {
//     throw Exception('Failed to load nearby hospitals');
//   }
// }
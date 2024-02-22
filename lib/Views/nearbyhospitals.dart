import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:map_launcher/map_launcher.dart';

import '../data/hospitals.dart';
import '../data/theme.dart';

class NearbyHospitalsPage extends StatefulWidget {

  // NearbyHospitalsPage(
  //     {required this.latitude, required this.longitude});
  //     );

  @override
  _NearbyHospitalsPageState createState() => _NearbyHospitalsPageState();
}

class _NearbyHospitalsPageState extends State<NearbyHospitalsPage> {
  List<dynamic> hospitals = [];
  late Position position;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      fetchNearbyHospitals();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchNearbyHospitals() async {
    final apiKey = 'AIzaSyD9aYD2LXsWn_Zx8rCSQ_DUPAjfoavM4lE';
    var headers = {
      // 'Content-Type': 'application/json',
      'X-Goog-Api-Key': 'AIzaSyD9aYD2LXsWn_Zx8rCSQ_DUPAjfoavM4lE',
      'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.location,places.rating'
    };
    // position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    //
    var url = 'https://places.googleapis.com/v1/places:searchNearby';
    print("lati = ${position.latitude} and long = ${position.longitude}");
    //
    // http.Request request;
    // try {
    //   request = http.Request('POST',
    //       Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));
    //   request.body = json.encode({
    //     "includedTypes": ["hospital"],
    //     "locationRestriction": {
    //       "circle": {
    //         "center": {
    //           "latitude": '${position.latitude.toString()}',
    //           "longitude": '${position.longitude.toString()}'
    //         },
    //         "radius": 1000.0
    //       }
    //     }
    //   });
    //
    // } on Exception catch (e) {
    //   print(e);
    // }

    // request.headers.addAll(headers);

    // http.StreamedResponse responseNew = await request.send();

    final dio = Dio();


      try {
        Response response;
        response = await dio.post(url, options: Options(
          headers: headers,
        ), data: {
          "includedTypes": ["hospital"],
          "locationRestriction": {
            "circle": {
              "center": {
                "latitude": position.latitude,
                "longitude": position.longitude
              },
              "radius": 1000.0
            }
          }
        });

        print(response.data);

        final List<dynamic> places = response.data['places'];

        setState(() {
          hospitals = List<Hospital>.from(places.map((place) => Hospital.fromJson(place)));
          isLoading = false; // Set loading indicator to false
        });

        print(response.data['places']);
      } on DioException catch (e) {
        print(e);
      }
    }

    // @override
    // Widget build(BuildContext context){
    //   return Scaffold(
    //     body: Center(
    //       child: ElevatedButton(
    //         onPressed: () {
    //           fetchNearbyHospitals();
    //         } ,
    //         child: Text("CHECK LIST DATA"),
    //       ),
    //     ),
    //   );


    @override
    Widget build(BuildContext context) {
      print("COUNT IS =${hospitals.length}");
      return
        MaterialApp(
          theme: ThemeManager.lightTheme,
          home:
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: const Color(0xFF454587),
              title: const Text(
                'Nearby Hospitals', style: TextStyle(color: Colors.white),),
            ),
            body: Center(
              child:
              isLoading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  double latitude = hospitals[index].location['latitude'];
                  double longitude = hospitals[index].location['longitude'];

                  final hospital = hospitals[index];
                  return ListTile(
                    title: Text("Name: ${hospital.displayName['text']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Address: ${hospital.formattedAddress}",
                            textAlign: TextAlign.center),
                        Text(
                          'Latitude: ${hospital.location['latitude']
                              .toStringAsFixed(4)}, Longitude: ${hospital
                              .location['longitude'].toStringAsFixed(4)}',
                        ),
                        distance(
                            position.latitude, position.longitude, latitude,
                            longitude),
                        RatingBarWidget(hospital.rating),
                        Text("rating: ${hospital.rating}"),
                        MapElevatedButton(
                            latitude, longitude, hospital.formattedAddress),
                        const Divider()
                      ],
                    ),
                  );
                },
              ),
            ),
          )
          ,);
    }


    Widget MapElevatedButton(double lat, double long, String address) {
      return ElevatedButton(onPressed: () async {
        if (await MapLauncher.isMapAvailable(MapType.google) == true) {
          await MapLauncher.showMarker(
            mapType: MapType.google,
            coords: Coords(lat, long),
            title: address,
          );
        } else {
          Fluttertoast.showToast(msg: "YOU DON'T HAVE GOOGLE MAPS");
        }
      },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("OPEN IN MAPS"),
              Icon(Icons.arrow_forward_rounded)
            ],));
    }

    Widget RatingBarWidget(String rating) {
      return RatingBarIndicator(
        rating: double.parse(rating),
        itemBuilder: (context, index) =>
            Icon(
              Icons.star,
              color: Colors.amber,
            ),
        itemCount: 5,
        itemSize: 30.0,
        direction: Axis.horizontal,
      );
    }

    Widget distance(lat1, long1, lat2, long2) {
      double dis = FlutterMapMath().distanceBetween(
          lat1, long1, lat2, long2, "kilometers");
      // double dis = acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(long2-long1))*6371;
      return Text("DISTANCE : ${dis.toString()}");
    }
  }


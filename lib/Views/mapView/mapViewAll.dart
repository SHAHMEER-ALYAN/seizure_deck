// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewAll extends StatefulWidget {
  const MapViewAll({super.key});

  @override
  State<MapViewAll> createState() => _MapViewAllState();
}

class _MapViewAllState extends State<MapViewAll> {
  late GoogleMapController mapController;
  List<Marker> markers = <Marker>[];
  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: codGray,
        // appBar: customAppbar(
        //     centerTitle: true,
        //     isBold: true,
        //     text: 'MapViewAll',
        //     onTap: () => {
        //       Get.back()
        //     },
        //     showBackButton: true),
        body: GoogleMap(
          mapType: MapType.satellite,
          initialCameraPosition: const CameraPosition(
              target: LatLng(24.914440, 67.029831), zoom: 100),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            markers.add(Marker(
              markerId: const MarkerId('value'),
              position: const LatLng(24.914440, 67.029831),
              icon: customMarker,
            ));
          },
          markers: Set<Marker>.of(markers),
        ),
        );
  }
}

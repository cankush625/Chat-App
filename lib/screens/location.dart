import 'dart:async';

import 'package:flutter/material.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Map<String, Position> data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    Completer<GoogleMapController> _controller = Completer();
    Position position = data['location'];
    final CameraPosition _myLocation = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 9);
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _myLocation,
          mapType: MapType.normal,
          compassEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      )
    );
  }

}
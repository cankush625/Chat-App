import 'dart:async';

import 'package:flutter/material.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, Object> data = {};
  Future<Map<String, String>> place;
  Position position;
  String featureName;
  String countryName;
  String postalCode;
  String state;
  String district;

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    position = data['location'];
    featureName = data['featureName'];
    postalCode = data['postalCode'];
    district = data['district'];
    state = data['state'];
    countryName = data['countryName'];
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ankush Chavan'
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: deviceWidth,
                  height: deviceWidth,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network(
                      'https://avatars1.githubusercontent.com/u/41515472?s=400&u=2e83d208268b51f32d5212de73328a501ecd4ce5&v=4',
//                    width: deviceWidth,
//                    height: deviceWidth,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 360, 0, 0),
                  child: Text(
                    'Ankush Chavan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ]
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      size: 30,
                    ),
                    title: Text(
                      featureName,
                    ),
                    subtitle: Text(
                      '$postalCode, $district, $state',
                    ),
                  ),
                  MaterialButton(
                    child: Text(
                      'Show on map',
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'location', arguments: {'location': position});
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
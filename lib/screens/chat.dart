import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

Map<String, Position> geoPosition;

class _ChatState extends State<Chat> {
  var messageTextController = TextEditingController();

  var fs = FirebaseFirestore.instance;
  var authc = FirebaseAuth.instance;

  String chatMessage;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var currentUserEmail = authc.currentUser.email;
    var currentUser;
    var addresses;
    var first;

    Future<Map<String, String>> _getPlaceMark(Position position) async {
      final CameraPosition _myLocation = CameraPosition(target: LatLng(position.latitude, position.longitude),);
      final coordinates = new Coordinates(position.latitude, position.longitude);
      addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      first = addresses.first;
      return {'featureName': first.featureName, 'countryName': first.countryName, 'postalCode': first.postalCode, 'state': first.adminArea, 'district': first.subAdminArea};
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          title: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                  Future<Map<String, String>> placeMark = _getPlaceMark(position);
                  String featureName;
                  String countryName;
                  String postalCode;
                  String state;
                  String district;
                  await placeMark.then((value) => {
                    featureName = value['featureName'],
                    countryName = value['countryName'],
                    postalCode = value['postalCode'],
                    state = value['state'],
                    district = value['district'],
                  });
                  Navigator.pushNamed(context, 'profile', arguments: {
                    'location': position,
                    'featureName': featureName,
                    'countryName': countryName,
                    'postalCode': postalCode,
                    'state': state,
                    'district': district,
                  });
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  width: deviceWidth * 0.1,
                  height: deviceWidth * 0.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://avatars1.githubusercontent.com/u/41515472?s=400&u=2e83d208268b51f32d5212de73328a501ecd4ce5&v=4',
                      ),
                    ),
                    borderRadius: BorderRadius.circular(deviceWidth * 0.50),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Text('Ankush Chavan'),
            ],
          ),
        ),
        body: FooterLayout(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 25,
                  width: 70,
                  child: Center(
                    child: Text(
                      "TODAY",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          builder: (context, snapshot) {

                            var msg = snapshot.data.docs;

                            List<Widget> y = [];
                            for (var d in msg) {
                              var msgText = d.data()['text'];
                              var msgSender = d.data()['name'];
                              print("****************" +d.id);
                              var msgWidget = Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        "$msgText : $msgSender",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                               ],
                              );

                              y.add(msgWidget);
                            }

                            print(y);

                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: y,
                              ),
                            );
                          },
                          stream: fs.collection("chat").snapshots(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          footer: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.fromLTRB(deviceWidth * 0.01, deviceWidth * 0.01, deviceWidth * 0.01, 5),
                  width: deviceWidth * 0.84,
                  child: TextField(
                    controller: messageTextController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      chatMessage = value;
                    },
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(deviceWidth * 42.5),
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  width: deviceWidth * 0.14,
                  child: FlatButton(
                    child: Icon(
                      Icons.send,
                      color: Colors.blueAccent[700],
                      size: 35,
                    ),
                    onPressed: () async {
                      messageTextController.clear();
                      await fs.collection("user").doc(currentUserEmail)
                          .get().then((value) => currentUser = value["name"].toString());

                      await fs.collection("chat").add({
                        "text": chatMessage,
                        "sender": currentUserEmail,
                        "name": currentUser,
                      });
                      print(currentUserEmail);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var messageTextController = TextEditingController();

  var fs = FirebaseFirestore.instance;
  var authc = FirebaseAuth.instance;

  String chatMessage;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var currentUserEmail = authc.currentUser.email;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          title: Row(
            children: <Widget>[
              Container(
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
              Text('Ankush'),
            ],
          ),
        ),
        body: FooterLayout(
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
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: StreamBuilder<QuerySnapshot>(
                            builder: (context, snapshot) {

                              var msg = snapshot.data.docs;
                              // print(msg);
                              // print(msg[0].data());

                              List<Widget> y = [];
                              for (var d in msg) {
                                // print(d.data()['sender']);
                                var msgText = d.data()['text'];
                                var msgSender = d.data()['sender'];
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          footer: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.fromLTRB(deviceWidth * 0.01, 0, deviceWidth * 0.01, 5),
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
                padding: EdgeInsets.only(bottom: 5),
                child: FlatButton(
                  child: Icon(
                    Icons.send,
                    color: Colors.blueAccent[700],
                    size: 35,
                  ),
                  onPressed: () async {
                    messageTextController.clear();

                    await fs.collection("chat").add({
                      "text": chatMessage,
                      "sender": currentUserEmail,
                    });
                    print(currentUserEmail);
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}

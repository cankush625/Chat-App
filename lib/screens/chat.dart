import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class MyChat extends StatefulWidget {
  @override
  _MyChatState createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  var msgtextcontroller = TextEditingController();

  var fs = FirebaseFirestore.instance;
  var authc = FirebaseAuth.instance;

  String chatmsg;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var signInUser = authc.currentUser.email;

    return Scaffold(
        appBar: AppBar(
          title: Text('chat'),
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
                  color: Colors.yellowAccent[100],
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
                              print('new data comes');

                              var msg = snapshot.data.docs;
                              // print(msg);
                              // print(msg[0].data());

                              List<Widget> y = [];
                              for (var d in msg) {
                                // print(d.data()['sender']);
                                var msgText = d.data()['text'];
                                var msgSender = d.data()['sender'];
                                var msgWidget = Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen[200],
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
                width: deviceWidth * 0.70,
                child: TextField(
                  controller: msgtextcontroller,
                  decoration: InputDecoration(hintText: 'Enter msg ..'),
                  onChanged: (value) {
                    chatmsg = value;
                  },
                ),
              ),
              Container(
                width: deviceWidth * 0.20,
                child: FlatButton(
                  child: Text('send'),
                  onPressed: () async {
                    msgtextcontroller.clear();

                    await fs.collection("chat").add({
                      "text": chatmsg,
                      "sender": signInUser,
                    });
                    print(signInUser);
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}

import 'package:arya_ediga_app_1v/aboutus.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'package:arya_ediga_app_1v/deleteprofile.dart';
import 'package:arya_ediga_app_1v/editprofile.dart';
import 'package:arya_ediga_app_1v/feedback.dart';
import 'package:arya_ediga_app_1v/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Appettings extends StatefulWidget {
  Appettings({Key? key}) : super(key: key);

  final String title = 'i am good';

  @override
  _AppettingsState createState() => _AppettingsState();
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class _AppettingsState extends State<Appettings> {
  final cuser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('user_profile');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(cuser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              primary: false,
              appBar: EmptyAppBar(),
              body: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        color: Colors.orange,
                      ),
                      Positioned(
                          bottom: 150,
                          left: -40,
                          child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color:
                                    Colors.yellowAccent[100]!.withOpacity(0.1)),
                          )),
                      Positioned(
                          top: -120,
                          left: 100,
                          child: Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color:
                                    Colors.yellowAccent[100]!.withOpacity(0.1)),
                          )),
                      Positioned(
                          top: -50,
                          left: 0,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color:
                                    Colors.yellowAccent[100]!.withOpacity(0.1)),
                          )),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(75),
                                color:
                                    Colors.yellowAccent[100]!.withOpacity(0.1)),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 35.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "App Settings",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Material(
                                elevation: 2.0,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data['username'],
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            data['email'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  getGridView()
                ],
              ),
            );
          }

          return Scaffold(body: Center(child: Text("Loading")));
        });
  }

  int _selectedIndex = -1;

  Widget getGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      primary: false,
      childAspectRatio: (MediaQuery.of(context).size.width - 60 / 2) / 280,
      children: <Widget>[
        createTile(0, false, 'Edit Profile', Colors.orangeAccent, Icons.edit),
        createTile(1, true, 'About Us', Colors.cyan, Icons.local_activity),
        createTile(2, false, 'FeedBack', Colors.green, Icons.feedback_outlined),
        createTile(3, true, 'Delete Profile', Colors.redAccent, Icons.delete),
        createTile(4, false, 'Sign Out', Colors.blueAccent, Icons.logout),
      ],
    );
  }

  Widget createTile(
      int index, bool isEven, String title, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(
          left: isEven ? 10 : 20, right: isEven ? 20 : 10, top: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            if (_selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Editprofile()),
              );
            } else if (_selectedIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Aboutus()),
              );
            } else if (_selectedIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Feedbackform()),
              );
            } else if (_selectedIndex == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cdeleteprofile()),
              );
            } else if (_selectedIndex == 4) {
              context.read<AuthenticationService>().signOut();
              Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthenticationWrapper()),
              );
            } else {}
          },
          child: Material(
            elevation: 3.0,
            color: _selectedIndex == index ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    icon,
                    color: _selectedIndex == index ? Colors.white : color,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 3.0,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:
                                _selectedIndex == index ? Colors.orange : color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

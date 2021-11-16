import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Viewinfo extends StatefulWidget {
  const Viewinfo({Key? key}) : super(key: key);

  @override
  _ViewinfoState createState() => _ViewinfoState();
}

class _ViewinfoState extends State<Viewinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(102, 102, 102, 1),
        ),
        title: Text(
          "Arya Ediga App",
          style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1), fontFamily: 'Lobster'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Appettings()));
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    "View Infomation",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Avenir',
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  height: 800,
                  child: Center(
                    child: Viewinfolis(),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class Viewinfolis extends StatefulWidget {
  @override
  _ViewinfolisState createState() => _ViewinfolisState();
}

class _ViewinfolisState extends State<Viewinfolis> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('student_view_info').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
              child: Center(
            child: Text("Something went wrong"),
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              child: Center(
            child: Text("Loading"),
          ));
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Center(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      title: Text(
                        data['title'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                      subtitle: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 5)),
                          SizedBox(
                            width: double.infinity,
                            child: Text(DateFormat.yMMMd()
                                .add_jm()
                                .format((data['published_date'].toDate()))
                                .toString()),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_outlined),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detailsview(data)));
                      }),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Detailsview extends StatelessWidget {
  var infodata;
  Detailsview(this.infodata);

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot<Map<String, dynamic>>> wemideaUser =
        FirebaseFirestore.instance
            .collection('wemedia_profile')
            .doc(infodata['wid'])
            .get();

    return FutureBuilder(
      future: wemideaUser,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                title: Text(
                  "Arya Ediga App",
                  style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1),
                      fontFamily: 'Lobster'),
                ),
                backgroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Text("Loading"),
                ),
              ));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['account'] == 'active') {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                title: Text(
                  "Arya Ediga App",
                  style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1),
                      fontFamily: 'Lobster'),
                ),
                backgroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            infodata["title"],
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              fontSize: 24,
                            ),
                          ),
                          subtitle: Text(DateFormat.yMMMd()
                              .add_jm()
                              .format((infodata['published_date'].toDate()))
                              .toString()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 10, left: 20, right: 20),
                        child: Text(
                          '\t\t\t\t\t\t' + infodata['desc'],
                          style: TextStyle(
                              fontSize: 17,
                              letterSpacing: 0.5,
                              fontFamily: 'KaiseiHarunoUmi'),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                'Published By',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'KaiseiHarunoUmi',
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ),
                          Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(data['profile_photo']),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 15),
                              child: Text(
                                data['profile_name'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromRGBO(30, 30, 30, 1),
                                  fontFamily: 'KaiseiHarunoUmi',
                                ),
                              ),
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return Text("Something went worng");
      },
    );
  }
}

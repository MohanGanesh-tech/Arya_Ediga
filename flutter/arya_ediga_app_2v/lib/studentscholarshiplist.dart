import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/studentapplyscholarship.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scholarshiplist extends StatefulWidget {
  const Scholarshiplist({Key? key}) : super(key: key);

  @override
  _ScholarshiplistState createState() => _ScholarshiplistState();
}

class _ScholarshiplistState extends State<Scholarshiplist> {
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
                    "List of Scholarships",
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
                  height: 650,
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
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('student_scholarship_types')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
              child: Center(
            child:
                Text("Something went wrong", textDirection: TextDirection.ltr),
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              child: Center(
            child: Text("Loading", textDirection: TextDirection.ltr),
          ));
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 12),
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
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic),
                    ),
                    subtitle: Column(
                      children: [
                        Text(data['desc']),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Start Date: " + data['start_date'],
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Last Date: " + data['last_date'],
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    trailing: ElevatedButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Scholarshippage(sid: document.id)),
                            ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                        ),
                        child: Text('Apply')),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

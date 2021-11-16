import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Committee extends StatefulWidget {
  const Committee({Key? key}) : super(key: key);

  @override
  _CommitteeState createState() => _CommitteeState();
}

class _CommitteeState extends State<Committee> {
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
                    "Committee Members",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Avenir',
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  height: 650,
                  child: Center(
                    child: UserInformation(),
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

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('authorized_staffs').snapshots();

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
          padding: const EdgeInsets.only(bottom: 8),
          child: Center(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        data['imageurl'],
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(data['name'], textDirection: TextDirection.ltr),
                    subtitle: Text(data['designation']),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detailsview(post: data)));
                    });
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Detailsview extends StatefulWidget {
  var post;
  Detailsview({required this.post});
  @override
  _DetailsviewState createState() => _DetailsviewState();
}

class _DetailsviewState extends State<Detailsview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Arya Ediga App",
          style: TextStyle(color: Colors.white, fontFamily: 'Avenir'),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: ClipOval(
                child: Image.network(
                  widget.post['imageurl'],
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: ListTile(
                title: Row(children: <Widget>[
                  Text(widget.post["name"],
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Avenir',
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 24)),
                  // Icon(Icons.verified),
                ]),
                subtitle: Text(widget.post["designation"],
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Avenir',
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                trailing: Icon(Icons.verified),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                widget.post['desc'],
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

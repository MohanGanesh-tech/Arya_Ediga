import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewappliedHostellist extends StatefulWidget {
  const ViewappliedHostellist({Key? key}) : super(key: key);

  @override
  _ViewappliedHostellistState createState() => _ViewappliedHostellistState();
}

class _ViewappliedHostellistState extends State<ViewappliedHostellist> {
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
            margin: EdgeInsets.only(top: 30, left: 30),
            child: Text(
              "View Hostel Status",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Avenir',
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 22),
            ),
          ),
          Container(
            height: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
      .collection('student_hostel_application')
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
                if (data['uid'] == FirebaseAuth.instance.currentUser!.uid) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        data['hostelid'],
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                      trailing: ElevatedButton(
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Viewappliedhostelstatus(shid: data)),
                              ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                          ),
                          child: Text('View')),
                    ),
                  );
                }
                return ListTile();
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Viewappliedhostelstatus extends StatefulWidget {
  var shid;
  Viewappliedhostelstatus({required this.shid});
  @override
  _ViewappliedhostelstatusState createState() =>
      _ViewappliedhostelstatusState();
}

class _ViewappliedhostelstatusState extends State<Viewappliedhostelstatus> {
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
        child: Container(
          margin: const EdgeInsets.only(bottom: 60.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Center(
                        child: Text(
                          "Hostel Application Status",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              fontSize: 22),
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, right: 15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.shid['student_photo'],
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.shid['fname'] +
                                        "\t" +
                                        widget.shid['lname'],
                                    style: TextStyle(
                                        color: Color.fromRGBO(75, 75, 75, 1),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(widget.shid['phone']),
                                  Text(widget.shid['email']),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Text(widget.shid['address']),
                                  Text(widget.shid['district'] +
                                      "\t" +
                                      widget.shid['state']),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hostel:\t" + widget.shid['hostelid']),
                            Text("Status:\t" + widget.shid['status']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Income and Cast",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          Card(
                            child: Image.network(
                              widget.shid['income_cast'],
                              width: 150,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Aadhar Card",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          Card(
                            child: Image.network(
                              widget.shid['aadharcard'],
                              width: 150,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Fee Recipte",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          Card(
                            child: Image.network(
                              widget.shid['fee_recipte'],
                              width: 150,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Marks Card",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          Card(
                            child: Image.network(
                              widget.shid['markscard'],
                              width: 150,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

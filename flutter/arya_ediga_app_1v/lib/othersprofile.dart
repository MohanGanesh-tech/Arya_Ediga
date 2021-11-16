import 'package:arya_ediga_app_1v/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:arya_ediga_app_1v/appsettings.dart';

// ignore: must_be_immutable
class Otherprofile extends StatelessWidget {
  var userdata;
  Otherprofile(this.userdata);
  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot<Map<String, dynamic>>> users = FirebaseFirestore
        .instance
        .collection('user_profile')
        .doc(userdata)
        .get();
    print(userdata);

    return FutureBuilder<DocumentSnapshot>(
        future: users,
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
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Color.fromRGBO(102, 102, 102, 1),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Appettings()));
                      },
                    ),
                  ],
                  backgroundColor: Colors.white,
                ),
                body: Stack(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('./assets/images/bg9.jpg'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter)),
                  ),
                  Container(
                    height: 800,
                    child: Center(
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 30)),
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                image: NetworkImage(data['photo']),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              border: Border.all(
                                color: Color.fromRGBO(242, 242, 242, 1),
                                width: 4.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            data['username'],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontFamily: 'Damion',
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            data['email'],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "Bio: " + data['bio'],
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: 'Lobster',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 270),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                        color: Color.fromRGBO(242, 242, 242, 1),
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 8, left: 105, right: 105),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0)),
                                  color: Colors.amber,
                                ),
                                child: Center(
                                  child: Text(
                                    'My Post\'s',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Lobster',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Postcards(userdata),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]));
          }
          return Text("loading");
        });
  }
}

class Postcards extends StatelessWidget {
  var userdata;
  Postcards(this.userdata);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user_posts')
          .where('uid', isEqualTo: userdata)
          .where('status', isEqualTo: 'active')
          .orderBy('createdOn', descending: true)
          .snapshots(),
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
          width: 385,
          child: Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GetUserName(data['uid']),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  data['photo'],
                                  width: 370.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        data['title'],
                        style: TextStyle(
                          color: Color.fromRGBO(77, 77, 77, 1),
                        ),
                      ),
                      subtitle: Text(data['desc']),
                      // trailing: Icon(Icons.more_vert),
                      // isThreeLine: true,
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => Postoptions(
                      //               post: data, docid: document.id)));
                      // },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot<Map<String, dynamic>>> users = FirebaseFirestore
        .instance
        .collection('user_profile')
        .doc(documentId)
        .get();

    return FutureBuilder<DocumentSnapshot>(
      future: users,
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
          return ListTile(
            leading: Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: NetworkImage(data['photo']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                // border: Border.all(
                //   color: Color.fromRGBO(115, 115, 115, 1),
                //   width: 0.2,
                // ),
              ),
            ),
            title: Text(
              data['username'],
              style: TextStyle(
                fontSize: 20.0,
                color: Color.fromRGBO(75, 75, 75, 1),
                fontFamily: 'Damion',
              ),
            ),
            // subtitle: Text(data['email']),
          );
        }

        return Text("loading");
      },
    );
  }
}

// class Postoptions extends StatefulWidget {
//   var post;
//   var docid;
//   Postoptions({required this.post, required this.docid});

//   @override
//   _PostoptionsState createState() => _PostoptionsState();
// }

// class _PostoptionsState extends State<Postoptions> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//         title: Text(
//           "Arya Ediga App",
//           style: TextStyle(color: Colors.white, fontFamily: 'Avenir'),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.only(left: 25, right: 25, top: 80),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 GetUserName(widget.post['uid']),
//                 Container(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Center(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(5),
//                           child: Image.network(
//                             widget.post['photo'],
//                             width: 310.0,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ListTile(
//                   title: Text(
//                     widget.post['title'],
//                     style: TextStyle(
//                       color: Color.fromRGBO(77, 77, 77, 1),
//                     ),
//                   ),
//                   subtitle: Text(widget.post['desc']),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 65, right: 65, bottom: 20),
//                   child: MaterialButton(
//                     onPressed: () {
//                       FirebaseFirestore.instance
//                           .collection('user_posts')
//                           .doc(widget.docid)
//                           .update({'status': "delete"});
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Navigation()),
//                       );
//                     },
//                     child: Text(
//                       'Delete Post',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontFamily: 'SFUIDisplay',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     color: Colors.pink,
//                     elevation: 0,
//                     minWidth: 400,
//                     height: 50,
//                     textColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

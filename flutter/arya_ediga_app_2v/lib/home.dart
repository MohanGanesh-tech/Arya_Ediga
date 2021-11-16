import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/othersprofile.dart';
import 'package:arya_ediga_app_1v/heart_animation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        child: Container(
          child: Column(
            children: <Widget>[
              Postcards(),
            ],
          ),
        ),
      ),
    );
  }
}

class Postcards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user_posts')
          .orderBy('createdOn', descending: true)
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
              child: Center(
            child:
                Text("Something went wrong ", textDirection: TextDirection.ltr),
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              child: Center(
            child: Text("Loading", textDirection: TextDirection.ltr),
          ));
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GetUserName(data),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class GetUserName extends StatefulWidget {
  var userdata;
  GetUserName(this.userdata);
  @override
  _GetUserNameState createState() => new _GetUserNameState(userdata);
}

class _GetUserNameState extends State<GetUserName> {
  bool isHeartAnimating = false;
  bool isLiked = false;
  var userdata;
  _GetUserNameState(this.userdata);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('user_profile')
          .doc(userdata['uid'])
          .get(),
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
          if (data['account'] == 'active') {
            return Column(
              children: [
                ListTile(
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Otherprofile(userdata['uid'])));
                    }),
                Column(
                  children: [
                    Container(
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  userdata['photo'],
                                  width: 370.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: isHeartAnimating ? 1 : 0,
                              child: HeartAnimationWidget(
                                isAnimating: isHeartAnimating,
                                duration: Duration(milliseconds: 700),
                                child: Icon(Icons.favorite,
                                    color: Colors.white, size: 80),
                                onEnd: () =>
                                    setState(() => isHeartAnimating = false),
                              ),
                            )
                          ],
                        ),
                        // onDoubleTap: () {
                        //   setState(() {
                        //     isHeartAnimating = true;
                        //     isLiked = true;
                        //   });
                        // },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userdata['title'],
                                style: TextStyle(
                                  color: Color.fromRGBO(77, 77, 77, 1),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                userdata['desc'],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // getlike(),
                              buildActions(userdata['like_by'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)),
                              Text(
                                (userdata['like_by'].length).toString(),
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " likes",
                                style: TextStyle(
                                    fontFamily: 'Damion', fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        }
        return Container(); //challanging
      },
    );
  }

  // Widget getlike() {
  //   if (userdata['like_by'].contains(FirebaseAuth.instance.currentUser!.uid)) {
  //     return IconButton(
  //       icon: new Icon(Icons.favorite_rounded),
  //       color: Colors.deepOrange,
  //       onPressed: () {
  //         FirebaseFirestore.instance
  //             .collection('user_posts')
  //             .doc('9xPofgXARbCGf5WkTBWB')
  //             .update({
  //           'likes_by': FieldValue.arrayRemove(
  //               [FirebaseAuth.instance.currentUser!.uid]),
  //         });
  //       },
  //     );
  //   } else {
  //     return IconButton(
  //       icon: new Icon(Icons.favorite_outline_rounded),
  //       color: Colors.grey,
  //       onPressed: () {
  //         FirebaseFirestore.instance
  //             .collection('user_posts')
  //             .doc('9xPofgXARbCGf5WkTBWB')
  //             .update({
  //           'likes_by':
  //               FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
  //         });
  //       },
  //     );
  //   }
  // }

  Widget buildActions(isLiked) {
    final icon = isLiked ? Icons.favorite : Icons.favorite_outline;
    final color = isLiked ? Colors.red : Colors.grey;

    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          HeartAnimationWidget(
            alwaysAnimate: true,
            isAnimating: isLiked,
            child: IconButton(
              onPressed: () => setState(
                () => {
                  isLiked = !userdata['like_by']
                      .contains(FirebaseAuth.instance.currentUser!.uid),
                  if (isLiked)
                    {
                      FirebaseFirestore.instance
                          .collection('user_posts')
                          .doc('9xPofgXARbCGf5WkTBWB')
                          .update({
                        'likes_by': FieldValue.arrayRemove(
                            [FirebaseAuth.instance.currentUser!.uid]),
                      })
                    }
                  else
                    {
                      FirebaseFirestore.instance
                          .collection('user_posts')
                          .doc('9xPofgXARbCGf5WkTBWB')
                          .update({
                        'likes_by': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser!.uid]),
                      })
                    }
                },
              ),
              icon: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}

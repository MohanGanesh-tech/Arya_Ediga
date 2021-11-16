import 'dart:io';
import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Editprofile extends StatefulWidget {
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  FilePickerResult? profilephoto;
  File? img;
  String imgcheck = 'Photo not Seleted';

  final cuser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  var existingimg;

  String? imageurl;

  bool _uname = true;
  bool _bio = true;
  bool _email = true;
  bool _phone = true;
  bool _gender = true;
  TextEditingController uname = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gender = TextEditingController();

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
            uname.text = data['username'];
            bio.text = data['bio'];
            email.text = data['email'];
            gender.text = data['gender'];
            phone.text = data['phone'];
            existingimg = data['photo'];

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
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Avenir',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22),
                                  ),
                                ),
                                getimagewidget(data),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Container(
                                    color: Color(0xfff5f5f5),
                                    child: ElevatedButton(
                                      child: Text('Upload Photo'),
                                      onPressed: () async {
                                        try {
                                          profilephoto = await FilePicker
                                              .platform
                                              .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'png',
                                              'jpeg',
                                              'webp'
                                            ],
                                          );
                                          if (profilephoto != null) {
                                            PlatformFile file =
                                                profilephoto!.files.first;
                                            print(file.name);
                                            print(file.size);
                                            print(file.extension);
                                            print(file.path);
                                            if (file.extension == 'jpg' ||
                                                file.extension == 'jpeg') {
                                              setState(() {
                                                img = File(profilephoto!
                                                    .files.first.path!);
                                              });
                                            } else if (file.extension ==
                                                    'png' ||
                                                file.extension == 'webp') {
                                              setState(() {
                                                img = File(profilephoto!
                                                    .files.first.path!);
                                              });
                                            } else {
                                              setState(() {
                                                img = null;
                                                imgcheck = 'Not Correct format';
                                              });
                                            }
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          "User Name",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextField(
                                        controller: uname,
                                        decoration: InputDecoration(
                                          hintText: data['username'],
                                          errorText: _uname
                                              ? null
                                              : "Please Enter Username",
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            "Bio",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                      TextField(
                                        controller: bio,
                                        decoration: InputDecoration(
                                          hintText: data['bio'],
                                          errorText:
                                              _bio ? null : "Please Enter Bio",
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            "Phone",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                      TextField(
                                        controller: phone,
                                        decoration: InputDecoration(
                                          hintText: data['phone'],
                                          errorText: _phone
                                              ? null
                                              : "Please Enter Phone",
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            "Gmail",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                      TextField(
                                        controller: email,
                                        decoration: InputDecoration(
                                          hintText: data['email'],
                                          errorText: _email
                                              ? null
                                              : "Please Enter Email",
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            "Gender",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )),
                                      TextField(
                                        controller: gender,
                                        decoration: InputDecoration(
                                          hintText: data['gender'],
                                          errorText: _gender
                                              ? null
                                              : "Please Enter Gender",
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Processing Data')),
                                              );

                                              setState(() {
                                                uname.text.isEmpty
                                                    ? _uname = false
                                                    : _uname = true;
                                              });
                                              setState(() {
                                                bio.text.isEmpty
                                                    ? _bio = false
                                                    : _bio = true;
                                              });
                                              setState(() {
                                                email.text.isEmpty
                                                    ? _email = false
                                                    : _email = true;
                                              });
                                              setState(() {
                                                gender.text.isEmpty
                                                    ? _gender = false
                                                    : _gender = true;
                                              });
                                              setState(() {
                                                phone.text.isEmpty
                                                    ? _phone = false
                                                    : _phone = true;
                                              });

                                              if (_uname && _bio) {
                                                if (_email && _email) {
                                                  if (_phone) {
                                                    print(profilephoto);

                                                    if (profilephoto != null) {
                                                      File file = File(
                                                          profilephoto!.files
                                                              .first.path!);
                                                      print(file);
                                                      print(profilephoto!
                                                          .files.first.name);

                                                      Reference ref =
                                                          firebase_storage
                                                              .FirebaseStorage
                                                              .instance
                                                              .ref('profile/' +
                                                                  profilephoto!
                                                                      .files
                                                                      .first
                                                                      .name);
                                                      UploadTask uploadTask =
                                                          ref.putFile(file);
                                                      var dowurl =
                                                          await (await uploadTask)
                                                              .ref
                                                              .getDownloadURL();
                                                      imageurl =
                                                          dowurl.toString();
                                                      print(imageurl);
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'user_profile')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'username': uname.text,
                                                        'bio': bio.text,
                                                        'email': email.text,
                                                        'phone': phone.text,
                                                        'gender': gender.text,
                                                        'photo': imageurl,
                                                        'lastupdate': FieldValue
                                                            .serverTimestamp()
                                                      });
                                                    }
                                                    if (profilephoto == null) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'user_profile')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'username': uname.text,
                                                        'bio': bio.text,
                                                        'email': email.text,
                                                        'phone': phone.text,
                                                        'gender': gender.text,
                                                        'lastupdate': FieldValue
                                                            .serverTimestamp()
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                              Navigator.pop(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Appettings()),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Update',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SFUIDisplay',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          color: Colors.blueAccent,
                                          elevation: 0,
                                          minWidth: 400,
                                          height: 50,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }
          return Text("loading");
        });
  }

  getimagewidget(data) {
    if (img != null) {
      return Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: FileImage(img!),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            border: Border.all(
              color: Color.fromRGBO(242, 242, 242, 1),
              width: 4.0,
            ),
          ),
        ),
      );
    } else if (existingimg != null) {
      return Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: NetworkImage(existingimg),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            border: Border.all(
              color: Color.fromRGBO(242, 242, 242, 1),
              width: 4.0,
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Icon(Icons.image),
          Text(imgcheck),
        ],
      );
    }
  }
}

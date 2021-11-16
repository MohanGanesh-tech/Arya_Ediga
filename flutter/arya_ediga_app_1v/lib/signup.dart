import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:arya_ediga_app_1v/login.dart';
import 'package:provider/provider.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'dart:io';
import 'package:email_validator/email_validator.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FilePickerResult? profilephoto;
  File? img;
  String imgcheck = '';

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController uname = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('./assets/images/bg6.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 270),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 23, right: 23, bottom: 0),
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Arya Ediga App",
                        style: TextStyle(
                            color: Color.fromRGBO(80, 80, 80, 1),
                            fontFamily: 'Lobster',
                            fontSize: 24),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    getimagewidget(),
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(90, 90, 90, 1),
                          ),
                          child: Text(
                            'Upload Photo',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            try {
                              profilephoto =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'png',
                                  'jpeg',
                                  'webp'
                                ],
                              );
                              if (profilephoto != null) {
                                PlatformFile file = profilephoto!.files.first;
                                print(file.name);
                                print(file.size);
                                print(file.extension);
                                print(file.path);
                                if (file.extension == 'jpg' ||
                                    file.extension == 'jpeg') {
                                  setState(() {
                                    img = File(profilephoto!.files.first.path!);
                                  });
                                } else if (file.extension == 'png' ||
                                    file.extension == 'webp') {
                                  setState(() {
                                    img = File(profilephoto!.files.first.path!);
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
                    Padding(padding: EdgeInsets.only(top: 0)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: uname,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Username';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username*',
                              prefixIcon: Icon(Icons.person_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: bio,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Bio';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Bio*',
                              prefixIcon: Icon(Icons.info_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: email,
                          validator: (value) => (EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email"),
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email*',
                              prefixIcon: Icon(Icons.mail_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Phone';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone*',
                              prefixIcon: Icon(Icons.phone),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Dob: " + "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(90, 90, 90, 1),
                            ),
                            onPressed: () => _selectDate(context),
                            child: Text(
                              'Select Date of Birth',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: gender,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Gender';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Gender*',
                              prefixIcon: Icon(Icons.person),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          } else if (value.length < 6) {
                            return 'Plese enter minimum 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password*',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            if (img != null) {
                              context.read<AuthenticationService>().signUp(
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                    bio: bio.text.trim(),
                                    phone: phone.text.trim(),
                                    username: uname.text.trim(),
                                    photofile: profilephoto,
                                    gender: gender.text.trim(),
                                    dob: selectedDate,
                                  );
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Image is not selected')));
                            }
                          }
                        },
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Color.fromRGBO(90, 90, 90, 1),
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Don you have an account?",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                            TextSpan(
                              text: " login",
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: Color(0xffff2d55),
                                fontSize: 15,
                              ),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    ),
                            )
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getimagewidget() {
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
    } else {
      return Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                './assets/images/user.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(imgcheck),
        ],
      );
    }
  }
}

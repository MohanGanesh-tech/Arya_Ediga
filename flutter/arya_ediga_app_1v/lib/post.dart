import 'dart:io';

import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'package:arya_ediga_app_1v/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();

  FilePickerResult? profilephoto;
  File? img;
  String imgcheck = '';

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30),
                  child: Text(
                    "New Post",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Avenir',
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                ),
                getimagewidget(),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white60,
                        ),
                        child: Text('Upload Photo'),
                        onPressed: () async {
                          try {
                            profilephoto = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'jpeg', 'webp'],
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
                                  imgcheck = 'format not supported';
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
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  child: TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Title';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  child: TextFormField(
                    controller: desc,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Description';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 80, right: 80),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Post')),
                          );

                          if (img != null) {
                            context.read<AuthenticationService>().newpost(
                                title: title.text.trim(),
                                desc: desc.text.trim(),
                                photofile: profilephoto);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation()),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Image is not selected')));
                        }
                      },
                      child: Text(
                        'Post',
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
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getimagewidget() {
    if (img != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.file(
            img!,
            width: 370.0,
            fit: BoxFit.fill,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                './assets/images/image_icon.png',
                width: 370.0,
                height: 250.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Center(
              child: Text(
            imgcheck,
            style: TextStyle(color: Colors.redAccent),
          )),
        ],
      );
    }
  }
}

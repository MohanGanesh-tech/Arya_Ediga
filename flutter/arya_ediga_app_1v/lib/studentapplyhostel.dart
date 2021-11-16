import 'dart:io';

import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'package:arya_ediga_app_1v/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Applyhostel extends StatefulWidget {
  final String hid;

  const Applyhostel({Key? key, required this.hid}) : super(key: key);

  @override
  _ApplyhostelState createState() => _ApplyhostelState();
}

class _ApplyhostelState extends State<Applyhostel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController account_no = TextEditingController();
  final TextEditingController schoolcollagename = TextEditingController();

  FilePickerResult? student_photo;
  FilePickerResult? income_cast;
  FilePickerResult? markscard;
  FilePickerResult? fee_recipte;
  FilePickerResult? aadharcard;

  File? studentphotoimg;
  String studentphotoimgcheck = '';

  File? incomecastimg;
  String incomecastimgcheck = '';

  File? markscardimg;
  String markscardimgcheck = '';

  File? feerecipteimg;
  String feerecipteimgcheck = '';

  File? aadharcardimg;
  String aadharcardimgcheck = '';

  String dropdownValue = 'Select';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

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
          padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Apply Hostel",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Avenir',
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  "Hostel:\t" + widget.hid,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Avenir',
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                        child: new Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: firstname,
                            onSaved: (value) {
                              print('saved');
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Firstname';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'First Name*',
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Container(
                      child: Flexible(
                        child: new Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: lastname,
                            onSaved: (value) {
                              print('saved');
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Last Name*',
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: phone,
                    onSaved: (value) {
                      print('saved');
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Phone number';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone number*',
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: email,
                    onSaved: (value) {
                      print('saved');
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email*',
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: schoolcollagename,
                    onSaved: (value) {
                      print('saved');
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter School/Collage name';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'School/Collage name*',
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    Text(
                      "Dob: " + "${selectedDate.toLocal()}".split(' ')[0],
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          'Select Date of Birth',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                        child: new Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: state,
                            onSaved: (value) {
                              print('saved');
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter State';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'State*',
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Container(
                      child: Flexible(
                        child: new Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: district,
                            onSaved: (value) {
                              print('saved');
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter District';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'District*',
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: address,
                    onSaved: (value) {
                      print('saved');
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Home Address*',
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),

                //Image ###########################################################################################

                Padding(padding: EdgeInsets.only(top: 40)),
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
                            "Aadhar Card",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          getaadharcardimgwidget(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(100, 100, 100, 1),
                              ),
                              child: Text(
                                'Upload\nAadhar Card',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  aadharcard =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'jpeg',
                                      'webp'
                                    ],
                                  );
                                  if (aadharcard != null) {
                                    PlatformFile file = aadharcard!.files.first;
                                    print(file.name);
                                    print(file.size);
                                    print(file.extension);
                                    print(file.path);
                                    if (file.extension == 'jpg' ||
                                        file.extension == 'jpeg') {
                                      setState(() {
                                        aadharcardimg =
                                            File(aadharcard!.files.first.path!);
                                      });
                                    } else if (file.extension == 'png' ||
                                        file.extension == 'webp') {
                                      setState(() {
                                        aadharcardimg =
                                            File(aadharcard!.files.first.path!);
                                      });
                                    } else {
                                      setState(() {
                                        aadharcardimg = null;
                                        aadharcardimgcheck =
                                            'format not supported';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Student Photo",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          getstudentphotoimgwidget(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(100, 100, 100, 1),
                              ),
                              child: Text(
                                'Upload\nStudent Photo',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  student_photo =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'jpeg',
                                      'webp'
                                    ],
                                  );
                                  if (student_photo != null) {
                                    PlatformFile file =
                                        student_photo!.files.first;
                                    print(file.name);
                                    print(file.size);
                                    print(file.extension);
                                    print(file.path);
                                    if (file.extension == 'jpg' ||
                                        file.extension == 'jpeg') {
                                      setState(() {
                                        studentphotoimg = File(
                                            student_photo!.files.first.path!);
                                      });
                                    } else if (file.extension == 'png' ||
                                        file.extension == 'webp') {
                                      setState(() {
                                        studentphotoimg = File(
                                            student_photo!.files.first.path!);
                                      });
                                    } else {
                                      setState(() {
                                        studentphotoimg = null;
                                        studentphotoimgcheck =
                                            'format not supported';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 40)),
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
                          getincomecastimgwidget(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(100, 100, 100, 1),
                              ),
                              child: Text(
                                'Upload\nIncome and Cast',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  income_cast =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'jpeg',
                                      'webp'
                                    ],
                                  );
                                  if (income_cast != null) {
                                    PlatformFile file =
                                        income_cast!.files.first;
                                    print(file.name);
                                    print(file.size);
                                    print(file.extension);
                                    print(file.path);
                                    if (file.extension == 'jpg' ||
                                        file.extension == 'jpeg') {
                                      setState(() {
                                        incomecastimg = File(
                                            income_cast!.files.first.path!);
                                      });
                                    } else if (file.extension == 'png' ||
                                        file.extension == 'webp') {
                                      setState(() {
                                        incomecastimg = File(
                                            income_cast!.files.first.path!);
                                      });
                                    } else {
                                      setState(() {
                                        incomecastimg = null;
                                        incomecastimgcheck =
                                            'format not supported';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Latest Marks Card",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          getmarkscardimgwidget(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(100, 100, 100, 1),
                              ),
                              child: Text(
                                'Upload\nMarks Card',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  markscard =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'jpeg',
                                      'webp'
                                    ],
                                  );
                                  if (markscard != null) {
                                    PlatformFile file = markscard!.files.first;
                                    print(file.name);
                                    print(file.size);
                                    print(file.extension);
                                    print(file.path);
                                    if (file.extension == 'jpg' ||
                                        file.extension == 'jpeg') {
                                      setState(() {
                                        markscardimg =
                                            File(markscard!.files.first.path!);
                                      });
                                    } else if (file.extension == 'png' ||
                                        file.extension == 'webp') {
                                      setState(() {
                                        markscardimg =
                                            File(markscard!.files.first.path!);
                                      });
                                    } else {
                                      setState(() {
                                        markscardimg = null;
                                        markscardimgcheck =
                                            'format not supported';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: 40)),
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
                            "Latest School/Collage\nFee Recipte",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                          getfeerecipteimgwidget(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(100, 100, 100, 1),
                              ),
                              child: Text(
                                'Upload\nFee Recipte',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  fee_recipte =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'jpeg',
                                      'webp'
                                    ],
                                  );
                                  if (fee_recipte != null) {
                                    PlatformFile file =
                                        fee_recipte!.files.first;
                                    print(file.name);
                                    print(file.size);
                                    print(file.extension);
                                    print(file.path);
                                    if (file.extension == 'jpg' ||
                                        file.extension == 'jpeg') {
                                      setState(() {
                                        feerecipteimg = File(
                                            fee_recipte!.files.first.path!);
                                      });
                                    } else if (file.extension == 'png' ||
                                        file.extension == 'webp') {
                                      setState(() {
                                        feerecipteimg = File(
                                            fee_recipte!.files.first.path!);
                                      });
                                    } else {
                                      setState(() {
                                        feerecipteimg = null;
                                        feerecipteimgcheck =
                                            'format not supported';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 30, right: 20, left: 20),
                  child: MaterialButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        context.read<AuthenticationService>().applyhostel(
                              hostelid: widget.hid.trim(),
                              fname: firstname.text.trim(),
                              lname: lastname.text.trim(),
                              phone: phone.text.trim(),
                              email: email.text.trim(),
                              state: state.text.trim(),
                              district: district.text.trim(),
                              address: address.text.trim(),
                              schoolcollagename: schoolcollagename.text.trim(),
                              student_photo: student_photo,
                              income_cast: income_cast,
                              markscard: markscard,
                              fee_recipte: fee_recipte,
                              aadharcard: aadharcard,
                            );
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  noimagewidget(msgs) {
    if (msgs != "") {
      return Column(
        children: [
          Center(
            child: Card(
              child: Image.asset(
                './assets/images/image_icon.png',
                width: 140,
                height: 180,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Center(
            child: Text(
              msgs,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      );
    } else
      return Column(
        children: [
          Center(
            child: Card(
              child: Image.asset(
                './assets/images/image_icon.png',
                width: 140,
                height: 180,
              ),
            ),
          ),
        ],
      );
  }

  getstudentphotoimgwidget() {
    if (studentphotoimg != null) {
      return Center(
        child: Card(
          child: Image.file(
            studentphotoimg!,
            width: 140,
            height: 180,
          ),
        ),
      );
    } else {
      return noimagewidget(studentphotoimgcheck);
    }
  }

  getincomecastimgwidget() {
    if (incomecastimg != null) {
      return Center(
        child: Card(
          child: Image.file(
            incomecastimg!,
            width: 140,
            height: 180,
          ),
        ),
      );
    } else {
      return noimagewidget(incomecastimgcheck);
    }
  }

  getmarkscardimgwidget() {
    if (markscardimg != null) {
      return Center(
        child: Card(
          child: Image.file(
            markscardimg!,
            width: 140,
            height: 180,
          ),
        ),
      );
    } else {
      return noimagewidget(markscardimgcheck);
    }
  }

  getfeerecipteimgwidget() {
    if (feerecipteimg != null) {
      return Center(
        child: Card(
          child: Image.file(
            feerecipteimg!,
            width: 140,
            height: 180,
          ),
        ),
      );
    } else {
      return noimagewidget(feerecipteimgcheck);
    }
  }

  getaadharcardimgwidget() {
    if (aadharcardimg != null) {
      return Center(
        child: Card(
          child: Image.file(
            aadharcardimg!,
            width: 140,
            height: 180,
          ),
        ),
      );
    } else {
      return noimagewidget(aadharcardimgcheck);
    }
  }

  //wait
}

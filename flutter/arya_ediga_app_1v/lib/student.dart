import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/studenteducation.dart';
import 'package:arya_ediga_app_1v/studenthostellist.dart';
import 'package:arya_ediga_app_1v/studentscholarshiplist.dart';
import 'package:arya_ediga_app_1v/studentviewinfo.dart';
import 'package:arya_ediga_app_1v/studentviewstatuslist.dart';
import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
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
        child: Column(
          children: <Widget>[
            Container(
              height: 900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Student",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Avenir',
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    height: 750,
                    child: ListView(children: <Widget>[getGridView()]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int _selectedIndex = -1;

  Widget getGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      primary: false,
      childAspectRatio: (MediaQuery.of(context).size.width - 60 / 2) / 280,
      children: <Widget>[
        createTile(0, false, 'View Information', Colors.blueAccent,
            Icons.info_outline),
        createTile(4, true, 'Education', Colors.lightGreen,
            Icons.cast_for_education_outlined),
        createTile(1, false, 'Apply Hostel', Colors.cyan, Icons.home_outlined),
        createTile(
            2, true, 'Apply Scholarship', Colors.orange, Icons.school_outlined),
        createTile(3, false, 'View Status', Colors.amber, Icons.all_inbox),
      ],
    );
  }

  Widget createTile(
      int index, bool isEven, String title, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(
          left: isEven ? 10 : 20, right: isEven ? 20 : 10, top: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            if (_selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Viewinfo()),
              );
            } else if (_selectedIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Hostellist()),
              );
            } else if (_selectedIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scholarshiplist()),
              );
            } else if (_selectedIndex == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Viewstatuslist()),
              );
            } else if (_selectedIndex == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Education()),
              );
            } else {}
          },
          child: Material(
            elevation: 3.0,
            color: _selectedIndex == index ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    icon,
                    color: _selectedIndex == index ? Colors.white : color,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 3.0,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:
                                _selectedIndex == index ? Colors.orange : color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

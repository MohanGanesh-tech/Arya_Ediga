import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/studentviewhostelstatus.dart';
import 'package:arya_ediga_app_1v/studentviewscholarshipstatus.dart';
import 'package:flutter/material.dart';

class Viewstatuslist extends StatefulWidget {
  const Viewstatuslist({Key? key}) : super(key: key);

  @override
  _ViewstatuslistState createState() => _ViewstatuslistState();
}

class _ViewstatuslistState extends State<Viewstatuslist> {
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
                      "View Status",
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
        createTile(
            1, false, 'View Hostel Status', Colors.cyan, Icons.home_outlined),
        createTile(0, true, 'View Scholarship Status', Colors.blueAccent,
            Icons.info_outline),
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
                MaterialPageRoute(
                    builder: (context) => Viewappliedscholarship()),
              );
            } else if (_selectedIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewappliedHostellist()),
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
                            fontSize: 16,
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

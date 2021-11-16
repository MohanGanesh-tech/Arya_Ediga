import 'package:arya_ediga_app_1v/enews.dart';
import 'package:flutter/material.dart';
import 'package:arya_ediga_app_1v/home.dart';
import 'package:arya_ediga_app_1v/student.dart';
import 'package:arya_ediga_app_1v/profile.dart';
import 'package:arya_ediga_app_1v/post.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    News(),
    Post(),
    Home(),
    Student(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.amp_stories_outlined,
                color: Color.fromRGBO(102, 102, 102, 1)),
            label: 'e-News',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.post_add,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            label: 'New Post',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school_outlined,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            label: 'Student',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_outlined,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
        selectedLabelStyle: TextStyle(fontStyle: FontStyle.italic),
        selectedItemColor: Color.fromRGBO(102, 102, 102, 1),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Construction")),
    );
  }
}

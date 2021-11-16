import 'package:arya_ediga_app_1v/committee.dart';
import 'package:arya_ediga_app_1v/developer.dart';
import 'package:flutter/material.dart';
import 'models/total_registered.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({Key? key}) : super(key: key);
  @override
  _AboutuspageState createState() => _AboutuspageState();
}

class _AboutuspageState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    constraints: BoxConstraints.expand(height: 150),
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xFF33BBB5), Color(0xFF95E08E)],
                            begin: const FractionalOffset(1.0, 1.0),
                            end: const FractionalOffset(0.2, 0.2),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  'About Us',
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 85),
                    constraints: BoxConstraints.expand(height: 200),
                    child: ListView(
                        padding: EdgeInsets.only(left: 40),
                        scrollDirection: Axis.horizontal,
                        children: getRecentJobs()),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 280),
                            child: Text("All About Arya Ediga App",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Avenir',
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24)),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Container(
                              child: Text(
                                "         We created this app to support Community and Students, The Ediga were categorised as an Other Backwards Class (OBC) since 1980s and our society is divided into small groups so we must maintain our unity in diversity of our society, We can make this possible by connecting the people of our society. \n \n    We also focus on helping Students, In our case students they are not getting proper Information, Education and Scholarship so we made app to overcome this problem. By using this app Student can apply Scholarship and track the scholarship and to get the proper Information and Education.",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<TotalMember> findtotalmem() {
    List<TotalMember> totalmembers = [];

    totalmembers.add(new TotalMember(2, "Committee Members", "Board Members"));
    totalmembers.add(
        new TotalMember(1, "Learn About Innovative Labs", "App Developer"));

    return totalmembers;
  }

  int _selectedIndex = -1;

  List<Widget> getRecentJobs() {
    List<Widget> tm = [];
    List<TotalMember> totalmembers = findtotalmem();
    for (TotalMember totalmember in totalmembers) {
      tm.add(getJobCard(totalmember));
    }
    return tm;
  }

  Widget getJobCard(TotalMember tm) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
      height: 150,
      width: 200,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = tm.id;
          });
          if (_selectedIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Developer()),
            );
          } else if (_selectedIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Committee()),
            );
          } else {}
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 8, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tm.title,
                  style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color(0xFF33BBB5),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    Text(tm.description,
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color(0xFF95E08E),
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Color(0xFF95E08E),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

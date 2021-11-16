import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Developer extends StatelessWidget {
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
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.redAccent, Colors.pinkAccent])),
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: AssetImage(
                              './assets/images/developer4.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
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
                        "Mohan Ganesh",
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Image.asset(
                                          './assets/images/icons8-instagram-logo-60.png',
                                          width: 35.0,
                                          height: 35.0,
                                        ),
                                        onPressed: () async {
                                          await launch(
                                              'https://www.instagram.com/mohan_ganesh_arya/');
                                        }),
                                    Text(
                                      "Instagram",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Image.asset(
                                          './assets/images/icons8-linkedin-60.png',
                                          width: 35.0,
                                          height: 35.0,
                                        ),
                                        onPressed: () async {
                                          await launch(
                                              'https://www.linkedin.com/in/ganesh-n-180ab6148/');
                                        }),
                                    Text(
                                      "Linkedin",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Image.asset(
                                          './assets/images/icons8-resume-website-50.png',
                                          width: 35.0,
                                          height: 35.0,
                                        ),
                                        onPressed: () async {
                                          await launch(
                                              'https://mohanganesh-tech.github.io/MyPortfolio/');
                                        }),
                                    Text(
                                      "Portfolio",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Image.asset(
                                          './assets/images/icons8-gmail-50.png',
                                          width: 35.0,
                                          height: 35.0,
                                        ),
                                        onPressed: () async {
                                          await launch(
                                              'http://ganeshn944870@gmail.com/');
                                        }),
                                    Text(
                                      "Gmail",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(
                    //   "Bio:",
                    //   style: TextStyle(
                    //       color: Colors.redAccent,
                    //       fontStyle: FontStyle.normal,
                    //       fontSize: 20.0),
                    // ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      '       I graduated with my degree in Computer Science Engineering, I choose that field of study because I’ve always been interested in technology and I am looking forward to build my own start-up company with bright idea and hope. \n\n'
                      '       I strongly believe technology is the future to solve the problems and make life better.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

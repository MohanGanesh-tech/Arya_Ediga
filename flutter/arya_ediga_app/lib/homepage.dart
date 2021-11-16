import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> registerbutton = [
    Container(
      padding: const EdgeInsets.only(bottom: 25),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {},
              child: Text('TextButton'),
            ),
          ],
        ),
      ),
    ),
    Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: FlutterLogo(size: 56.0),
              title: Text('Item 101'),
              subtitle: Text('Item 1 subtitle'),
              trailing: Icon(Icons.access_alarm),
            ),
          ],
        ),
      ),
    ),
    Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: FlutterLogo(size: 56.0),
              title: Text('Item 1'),
              subtitle: Text('Item 1 subtitle'),
              trailing: Icon(Icons.access_alarm),
            ),
          ],
        ),
      ),
    )
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Arya Ediga App'),
        ),
        body: Column(children: registerbutton));
  }
}

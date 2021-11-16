import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'package:arya_ediga_app_1v/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feedbackform extends StatefulWidget {
  const Feedbackform({Key? key}) : super(key: key);

  @override
  _FeedbackformState createState() => _FeedbackformState();
}

class _FeedbackformState extends State<Feedbackform> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController subject = TextEditingController();
  final TextEditingController body = TextEditingController();

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
          padding: EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Feedback',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Avenir',
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: subject,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Subject';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject*',
                        prefixIcon: Icon(Icons.feedback_outlined),
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: body,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Detail Feedback';
                      } else if (value.length < 6) {
                        return 'Plese enter minimum 6 characters';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Detail Feedback*',
                        prefixIcon: Icon(Icons.subject_outlined),
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feedback Sent')),
                        );
                        context.read<AuthenticationService>().feedback(
                              subject.text.trim(),
                              body.text.trim(),
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthenticationWrapper()),
                        );
                      }
                    },
                    child: Text(
                      'Send',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

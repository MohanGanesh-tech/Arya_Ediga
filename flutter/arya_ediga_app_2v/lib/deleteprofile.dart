import 'package:arya_ediga_app_1v/appsettings.dart';
import 'package:arya_ediga_app_1v/authentication_service.dart';
import 'package:arya_ediga_app_1v/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cdeleteprofile extends StatefulWidget {
  const Cdeleteprofile({Key? key}) : super(key: key);

  @override
  _CdeleteprofileState createState() => _CdeleteprofileState();
}

class _CdeleteprofileState extends State<Cdeleteprofile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController reason = TextEditingController();
  final TextEditingController pass = TextEditingController();

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
                  'Delete Account',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Avenir',
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Note: Once account is deleted, account cannot be recoverd.',
                  style: TextStyle(color: Colors.red),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: reason,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Resone';
                      } else if (value.length < 20) {
                        return 'Plese enter minimum 20 characters';
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Reason*',
                        prefixIcon: Icon(Icons.announcement_outlined),
                        labelStyle: TextStyle(fontSize: 15)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: pass,
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
                  padding: EdgeInsets.all(20),
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        context.read<AuthenticationService>().deteleprofile(
                              reason.text.trim(),
                              pass.text.trim(),
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthenticationWrapper()),
                        );
                      }
                    },
                    child: Text(
                      'Comfirm Delete',
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

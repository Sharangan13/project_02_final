import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PSell"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(25, 176, 47, 1),
            Color.fromRGBO(0, 0, 0, 10)
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SafeArea(
              child: Text(
                'Welcome bro!!!',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.green,
                    fontFamily: 'Times New Roman',
                    letterSpacing: 4),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Log Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => login_screen()));
                });
              },
            ),
          ],
        )),
      ),
      drawer: Drawer(
        elevation: 10,
      ),
    );
  }
}

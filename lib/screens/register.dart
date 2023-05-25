import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/reusable_widgets.dart';
import 'package:project_02_final/screens/login.dart';

import 'home.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _conformpasswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Register page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _userNameTextController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      icon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.trim().length < 4) {
                        return 'Username must be at least 4 characters in length';
                      }
                      // Return null if the entered username is valid
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    decoration: InputDecoration(
                      labelText: 'Enter Email Id',
                      icon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please Enter a Valid Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _phoneTextController,
                    decoration: InputDecoration(
                      labelText: 'Enter phone number',
                      icon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter a Phone Number";
                      } else if (!RegExp(
                              r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                          .hasMatch(value)) {
                        return "Please Enter a Valid Phone Number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordTextController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.trim().length < 8) {
                        return 'Password must be at least 8 characters in length';
                      }
                      // Return null if the entered password is valid
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _conformpasswordTextController,
                    decoration: InputDecoration(
                      labelText: 'Conform Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordTextController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  firebaseUIButton(context, "Register", () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        print("Ctrate new account");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => home()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }
                  }),
                  loginOption(),
                ],
              ),
            ),
          ))),
    );
  }

  Row loginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Colors.white70, fontSize: 15)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => login_screen()));
          },
          child: const Text(
            "  Login",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
  }
}

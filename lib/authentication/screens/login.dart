import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_02_final/authentication/controller/register_controller.dart';

import 'package:project_02_final/authentication/screens/register.dart';
import 'package:project_02_final/authentication/screens/reset_password.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import 'home.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);
  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final controller = Get.put(registerontroller());
  final _formKey = GlobalKey<FormState>();
  bool textvisible = true;
  String? emailError;
  String? passwordError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(25, 176, 47, 1),
            Color.fromRGBO(0, 0, 0, 10)
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Psell',
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                      letterSpacing: 4,
                    ),
                  ),
                  logoWidget('assets/images/logo1.png'),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: controller.email,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        labelText: "Enter Email address",
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.9)),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        errorText: emailError),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: controller.password,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                textvisible = !textvisible;
                              });
                            },
                            icon: textvisible
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  )),
                        labelText: "Password",
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.9)),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        errorText: passwordError),
                    obscureText: textvisible,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  forgetPassword(context),
                  const SizedBox(height: 20),
                  firebaseUIButton(context, "Login", () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: controller.email.text,
                        password: controller.password.text,
                      )
                          .then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => home()),
                        );
                      }).catchError((error) {
                        if (error.code == 'user-not-found') {
                          setState(() {
                            emailError = 'User not found';
                          });
                        } else if (error.code == 'wrong-password') {
                          setState(() {
                            passwordError = 'Incorrect password';
                          });
                        } else {
                          // Handle other errors if needed
                          print("Error: ${error.toString()}");
                        }
                      });
                    }
                  }),
                  registerOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row registerOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context as BuildContext,
                MaterialPageRoute(builder: (context) => const register()));
          },
          child: const Text(
            "  Register",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "forgot password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const resetpassword())),
      ),
    );
  }
}

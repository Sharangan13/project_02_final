import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_02_final/authentication/screens/home.dart';
import 'package:project_02_final/authentication/screens/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const home(),
    );
  }
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()),
      );
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("assets/images/logo1.png"),
                width: 300,
                color: Colors.white,
              ),
              SizedBox(
                height: 50,
              ),
              SpinKitChasingDots(
                color: Colors.yellow,
                size: 100.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  // return MaterialApp(
  //
  //   title: 'Flutter Demo',
  //   theme: ThemeData(
  //     // This is the theme of your application.
  //     //
  //     // Try running your application with "flutter run". You'll see the
  //     // application has a blue toolbar. Then, without quitting the app, try
  //     // changing the primarySwatch below to Colors.green and then invoke
  //     // "hot reload" (press "r" in the console where you ran "flutter run",
  //     // or simply save your changes to "hot reload" in a Flutter IDE).
  //     // Notice that the counter didn't reset back to zero; the application
  //     // is not restarted.
  //     primarySwatch: Colors.blue,
  //   ),
  //   home: const home(),
  // );
  // }
}
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_02_final/authentication/screens/home.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Abot Us'),
      ),
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),
              Text(
                'Welcome to our company! We are dedicated to providing the best products and services to our customers.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'To deliver high-quality products and exceptional services that exceed our customers\' expectations.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.phone,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.web,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.facebook,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    ),
    );
  }
}

import 'package:flutter/material.dart';

class SeeOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Orders'),
      ),
      body: Center(
        child: Text(
          'Orders will be displayed here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

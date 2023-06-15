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
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        actions: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 17,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Icons.shop,
                  size: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Kunarasa Tharsujan'),
              accountEmail: Text('kunarastharsujan@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.black,
                ),
              ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(25, 176, 47, 1),
                    Color.fromRGBO(0, 0, 0, 10)
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
            ),
            ListTile(
              dense: true,
              title: Text("My Account"),
              leading: Icon(Icons.person),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("Pre-Orders Bookings"),
              leading: Icon(Icons.add_box),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("Consultancy Bookings"),
              leading: Icon(Icons.add_box),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("Notifications"),
              leading: Icon(Icons.notifications_rounded),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("About us"),
              leading: Icon(Icons.contact_page_rounded),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("Rate us"),
              leading: Icon(Icons.star_rate),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("Your QR"),
              leading: Icon(Icons.qr_code),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: Text("Log out"),
              leading: Icon(Icons.arrow_back),
              onTap: () {
                //action when this menu is pressed
              },
            ),
          ],
        ),
        elevation: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child:Column(
          children:[
            Row(
              children: [
                Expanded(child:
                Container(
                  color:Colors.grey,
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      Text("Search products"),
                    ],
                  ),

                ),
                ),
              ],
            )
          ],
      )



      ),
    );

  }
}

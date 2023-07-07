import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:project_02_final/authentication/screens/update_profile.dart';
import 'AboutUsPage.dart';
import 'login.dart';
import 'package:project_02_final/components/horizontal_listview.dart';
import 'package:project_02_final/components/products.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/H1.png'),
          AssetImage('assets/images/H2.jfif'),
          AssetImage('assets/images/H3.jpg'),
          AssetImage('assets/images/H4.jfif')
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        dotColor: Colors.green,
        indicatorBgPadding: 2.0,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        actions: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 17,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 40,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Sharangan"),
              accountEmail: const Text("Sharangan199@gmail.com"),
              currentAccountPicture: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: Colors.lightGreen),
            ),
            ListTile(
              dense: true,
              title: const Text("My Account"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const updateProfile()),
                );
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Pre-Orders Bookings"),
              leading: const Icon(Icons.add_box),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Consultancy Bookings"),
              leading: const Icon(Icons.add_box),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Notifications"),
              leading: const Icon(Icons.notifications_rounded),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("About us"),
              leading: const Icon(Icons.contact_page_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                ); //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Rate us"),
              leading: const Icon(Icons.star_rate),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Your QR"),
              leading: const Icon(Icons.qr_code),
              onTap: () {
                //action when this menu is pressed
              },
            ),
            Divider(),
            ListTile(
              dense: true,
              title: const Text("Log out"),
              leading: const Icon(Icons.arrow_back),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const login_screen()),
                );
              },
            ),
          ],
        ),
      ),
      body: new ListView(
        children: [
          image_carousel,
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: new Text("SHOP FOR")),
          ),
          HorizontalList(),
          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: new Text("Recent Products")),
          ),
          Container(
            height: 320.0,
            child: Products(),
          )
        ],
      ),
    );
  }
}

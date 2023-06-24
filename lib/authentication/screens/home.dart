import 'package:flutter/material.dart';
import 'package:project_02_final/authentication/screens/update_profile.dart';
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
                //action when this menu is pressed
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://salisburygreenhouse.com/wp-content/uploads/Top-10-Plants-That-Make-You-Happy-main.png'),
                ),
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 130, bottom: 10),
                          ),
                          Text(
                            '15% Off',
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'On all plants until 13th may',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

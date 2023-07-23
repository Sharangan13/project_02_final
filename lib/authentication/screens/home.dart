import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_02_final/authentication/screens/Chat.dart';
import '../../components/RecentProductsPage.dart';
import 'AboutUsPage.dart';
import 'MyAccount.dart';
import 'ProductSearchScreen.dart';
import 'QRCodeRetrieval.dart';
import 'RateUs.dart';
import 'login.dart';
import 'package:project_02_final/components/horizontal_listview.dart';
import 'notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late User? user;
  late String accountName = "";
  late String accountEmail = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final documentId = currentUser.uid;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        setState(() {
          user = currentUser;
          accountName = userData?['UserName'] ?? '';
          accountEmail = userData?['Email'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = Container(
      height: 150.0,
      child: ListView(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/category/qwqw.jpg'),
              ),
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 150),
                          child: Container(
                            height: 70,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xffd1ad17),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Offer !!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(3, 3))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '30% Off',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.green[100],
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'On all Plants',
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
      ), //   boxFit: BoxFit.cover,
      //   images: [
      //     AssetImage('assets/images/H1.png'),
      //     AssetImage('assets/images/H2.jfif'),
      //     AssetImage('assets/images/H3.jpg'),
      //     AssetImage('assets/images/H4.jfif')
      //   ],
      //   autoplay: true,
      //   animationCurve: Curves.fastOutSlowIn,
      //   animationDuration: Duration(milliseconds: 1000),
      //   dotSize: 4.0,
      //   dotColor: Colors.green,
      //   indicatorBgPadding: 2.0,
      // ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductSearchScreen()),
                );
              },
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
              accountName: Text(accountName),
              accountEmail: Text(accountEmail),
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
              decoration: const BoxDecoration(color: Colors.green),
            ),
            ListTile(
              dense: true,
              title: const Text("My Account"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyAccount()),
                );
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Pre-Orders Bookings"),
              leading: const Icon(Icons.add_box),
              onTap: () {},
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyNotification()),
                ); //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Chat"),
              leading: const Icon(Icons.chat),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            receiverId: '',
                          )),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RateUsScreen()),
                ); //action when this menu is pressed
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Your QR"),
              leading: const Icon(Icons.qr_code),
              onTap: () {
                // action when this menu is pressed
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final uid = user.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRCodeRetrieval(uid: uid),
                    ),
                  );
                } else {
                  print('User authentication failed');
                  // Handle the error or show an error message to the user
                }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: new ListView(
          children: [
            image_carousel,
            new Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Center(child: new Text("SHOP FOR")),
            ),
            HorizontalList(),
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(child: new Text("Recent Plants")),
            ),
            Container(
              height: 340.0,
              child: RecentProductsPage(),
            )
          ],
        ),
      ),
    );
  }
}

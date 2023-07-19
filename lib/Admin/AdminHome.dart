import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AdminManagePage.dart';
import 'ConsultancyBookingDetailsPage.dart';
import 'MyAccountPage.dart';
import 'QrScannerPage.dart';
import 'SeeOrdersPage.dart';
import 'UploadPlantsEquipmentsPage.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Hello Sumo',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Good Morning',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/prf.jpg'),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrScannerPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'QR Scanner',
                      CupertinoIcons.phone,
                      Colors.pinkAccent,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeOrdersPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Orders',
                      CupertinoIcons.book_circle,
                      Colors.deepOrange,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String bookingId =
                          "ABC123"; // Replace with the actual booking ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultancyBookingDetailsPage(
                              bookingId: bookingId),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Consultancy Booking',
                      CupertinoIcons.graph_circle,
                      Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for Chat
                      // Add your code here
                    },
                    child: itemDashboard(
                      'Chat',
                      CupertinoIcons.chat_bubble_2,
                      Colors.teal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminManagePage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Manage Plants & Equipments',
                      CupertinoIcons.person_2,
                      Colors.purple,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadPlantsEquipmentsPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Upload Plants & Equipments',
                      CupertinoIcons.chat_bubble_2,
                      Colors.brown,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for sale details
                      // Add your code here
                    },
                    child: itemDashboard(
                      'Sale Details',
                      CupertinoIcons.money_dollar_circle,
                      Colors.indigo,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAccountPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'My Account',
                      CupertinoIcons.question_circle,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          )
        ],
      ),
    );
  }
}

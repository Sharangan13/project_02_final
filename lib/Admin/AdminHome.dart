import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../authentication/screens/login.dart';
import 'AddAdmin_ShowAdmin_screen.dart';
import 'AdminManagePage.dart';
import 'ConsultancyBookingDetailsPage.dart';
import 'QrScannerPage.dart';
import 'SeeOrdersPage.dart';
import 'SelectProductsPage.dart';
import 'UploadPlantsEquipmentsPage.dart';
import 'adminEditProfile.dart';

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
                    'Have a nice day',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: CircleAvatar(
                    radius: 40,
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
                      CupertinoIcons.qrcode_viewfinder,
                      Colors.black45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectProductsPage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Bill',
                      CupertinoIcons.creditcard,
                      Colors.lightGreen,
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
                      'See Orders',
                      CupertinoIcons.square_list,
                      Colors.teal,
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
                      CupertinoIcons.book_circle,
                      Colors.teal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap for Chat
                      // Add your code here
                    },
                    child: itemDashboard(
                      'Chat',
                      CupertinoIcons.bolt_horizontal_circle,
                      Colors.purple,
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
                      'Manage Plants and Equipments',
                      CupertinoIcons.doc_append,
                      Colors.grey,
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
                      'Upload Plants and Equipments',
                      CupertinoIcons.up_arrow,
                      Colors.brown,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: itemDashboard(
                      'Special Offers',
                      CupertinoIcons.tag,
                      Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
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
                          builder: (context) => AdminEditProfilePage(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'My Account',
                      CupertinoIcons.person,
                      Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: itemDashboard(
                      'Manage User',
                      CupertinoIcons.person_3,
                      Colors.teal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminScreen(),
                        ),
                      );
                    },
                    child: itemDashboard(
                      'Add a new Admin',
                      CupertinoIcons.person_2,
                      Colors.black38,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const login_screen()),
                      );
                    },
                    child: itemDashboard(
                      'Logout',
                      CupertinoIcons.return_icon,
                      Colors.indigo,
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
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

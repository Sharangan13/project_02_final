import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FcmTokenPage extends StatefulWidget {
  const FcmTokenPage({Key? key}) : super(key: key);

  @override
  State<FcmTokenPage> createState() => _FcmTokenPageState();
}

class _FcmTokenPageState extends State<FcmTokenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Tokens'),
      ),
      body: FcmTokenList(),
    );
  }
}

class FcmTokenList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('fcm_token').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final fcmTokens = snapshot.data!.docs;
        return ListView.builder(
          itemCount: fcmTokens.length,
          itemBuilder: (context, index) {
            final fcmTokenData =
                fcmTokens[index].data() as Map<String, dynamic>;
            final email = fcmTokenData['email'] ?? 'Unknown Email';
            final fcmToken = fcmTokenData['fcm'] ?? 'Unknown FCM Token';

            return Card(
              elevation: 3,
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  'Email: $email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('FCM Token: $fcmToken'),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class QRCodeShowPage extends StatelessWidget {
  final String qrCodeUrl;

  const QRCodeShowPage({Key? key, required this.qrCodeUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Widget>(
              future: _loadQRCodeImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return Text('Failed to load QR code image');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<Widget> _loadQRCodeImage() async {
    final imageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(qrCodeUrl);
    final url = await imageRef.getDownloadURL();
    return Image.network(
      url,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}

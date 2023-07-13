import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class QRCodeRetrieval extends StatefulWidget {
  final String uid;

  const QRCodeRetrieval({Key? key, required this.uid}) : super(key: key);

  @override
  _QRCodeRetrievalState createState() => _QRCodeRetrievalState();
}

class _QRCodeRetrievalState extends State<QRCodeRetrieval> {
  String? qrCodeUrl;

  @override
  void initState() {
    super.initState();
    retrieveQRCodeUrl();
  }

  Future<void> retrieveQRCodeUrl() async {
    try {
      String filePath =
          'qr_codes/${widget.uid}.png'; // Replace with your file path
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(filePath);

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        qrCodeUrl = await storageReference.getDownloadURL();
        setState(() {});
      }
    } catch (error) {
      print('Error retrieving QR code URL: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Your QR Code'),
      ),
      body: Center(
        child: qrCodeUrl != null
            ? QRCodeShowPage(
                downloadUrl:
                    qrCodeUrl!) // Pass downloadUrl instead of qrCodeUrl
            : CircularProgressIndicator(),
      ),
    );
  }
}

class QRCodeShowPage extends StatelessWidget {
  final String downloadUrl;

  const QRCodeShowPage({Key? key, required this.downloadUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        downloadUrl,
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}

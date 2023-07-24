import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrScannerPage extends StatefulWidget {
  @override
  _QrScannerPageState createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isCameraGranted = false;
  String qrCode = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    requestCameraPermission();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void requestCameraPermission() async {
    var status = await Permission.camera.request();
    setState(() {
      isCameraGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          if (isCameraGranted) _buildQrView(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Scan the QR code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (qrCode.isNotEmpty)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: FutureBuilder<DocumentSnapshot>(
                  future: getUserDetailsFromFirebase(qrCode),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userDetails = snapshot.data!.data();
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'User Details:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Display user details here
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error fetching data',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          if (isCameraGranted) // Add the focus box widget
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                margin: EdgeInsets.all(20.0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    if (!isCameraGranted) {
      return Center(
        child: Text(
          'Camera permission not granted',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  Future<DocumentSnapshot> getUserDetailsFromFirebase(String qrCode) async {
    final collectionRef = _firestore.collection('users');
    final userDocument = await collectionRef.doc(qrCode).get();
    return userDocument;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code!;
      });
    });
  }
}
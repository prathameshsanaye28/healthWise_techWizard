import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class QRScreen extends StatefulWidget {
  final String patientId;

  const QRScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String? qrId;

  @override
  void initState() {
    super.initState();
    _fetchQRCode();
  }

  Future<void> _fetchQRCode() async {
    DocumentSnapshot qrDoc = await FirebaseFirestore.instance
        .collection('patient_qr')
        .doc(widget.patientId)
        .get();

    if (qrDoc.exists) {
      setState(() {
        qrId = qrDoc['qrId'];
      });
    }
  }

  Future<void> _generateQRCode() async {
    if (qrId != null) return; // Prevent multiple QR generations

    String newQrId = const Uuid().v4(); // Generate unique qrId

    await FirebaseFirestore.instance
        .collection('patient_qr')
        .doc(widget.patientId)
        .set({
      'qrId': newQrId,
      'patientId': widget.patientId, // Store mapping
    });

    setState(() {
      qrId = newQrId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: qrId == null
          ? ElevatedButton(
              onPressed: _generateQRCode,
              child: const Text("Generate QR Code"),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: qrId!, // QR code stores ONLY qrId
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 20),
                Text("Scan this QR code to fetch patient details"),
              ],
            ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeDisplay extends StatelessWidget {
  final String qrCodeData;

  const QRCodeDisplay({super.key, required this.qrCodeData});

  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isBase64(qrCodeData)) {
      // Render base64 image from backend
      Uint8List bytes = base64Decode(qrCodeData);
      return Image.memory(bytes, height: 200, width: 200);
    } else {
      // Render as QR string
      return QrImageView(
        data: qrCodeData,
        version: QrVersions.auto,
        size: 200.0,
      );
    }
  }
}

class QRCodeCommissionedWork extends StatefulWidget {
  const QRCodeCommissionedWork({super.key});

  @override
  State<QRCodeCommissionedWork> createState() => _QRCodeCommissionedWorkState();
}

class _QRCodeCommissionedWorkState extends State<QRCodeCommissionedWork> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: MobileScanner(
        onDetect: (capture) {
          if (_hasScanned) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? rawValue = barcodes.first.rawValue;
            if (rawValue != null && rawValue.isNotEmpty) {
              _hasScanned = true;
              Navigator.of(context).pop(rawValue);
            }
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import '../models/validate_warranty.dart';

class ValidateWarrantyController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  WarrantyInfo? warrantyInfo;

  Future<void> decodeQrFromFile(File file) async {
    isLoading = true;
    error = null;
    warrantyInfo = null;
    notifyListeners();

    try {
      final inputImage = InputImage.fromFile(file);
      final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isEmpty) {
        error = "No QR code found in the image.";
        notifyListeners();
        return;
      }

      final qrData = barcodes.first.rawValue;
      if (qrData == null || qrData.isEmpty) {
        error = "QR code is empty.";
        notifyListeners();
        return;
      }

      final decodedJson = jsonDecode(qrData);
      warrantyInfo = WarrantyInfo.fromJson(decodedJson);
    } catch (e) {
      error = "Failed to decode QR: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}

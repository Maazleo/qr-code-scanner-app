import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan/scan.dart';
import '../models/qr_data.dart';

class QrScannerService {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  
  // This method is called when a barcode is detected in real-time
  QrData? processBarcode(Barcode barcode) {
    final String? rawValue = barcode.rawValue;
    
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }
    
    return QrData(
      data: rawValue,
      type: _determineType(rawValue),
      timestamp: DateTime.now(),
    );
  }
  
  // Scan QR code from gallery using the dedicated scan package
  Future<QrData?> scanFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) return null;
      
      // Use the scan package to read QR code from the image
      final String? result = await Scan.parse(image.path);
      
      if (result == null || result.isEmpty) {
        return null; // No QR code found in the image
      }
      
      // Create QR data from the scan result
      return QrData(
        data: result,
        type: _determineType(result),
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error scanning from gallery: $e');
      return null;
    }
  }
  
  // Determine the type of QR code data
  String _determineType(String data) {
    if (data.startsWith('http://') || data.startsWith('https://')) {
      return 'URL';
    } else if (data.contains('@') && data.contains('.')) {
      return 'Email';
    } else if (RegExp(r'^\+?[0-9\s-()]+$').hasMatch(data)) {
      return 'Phone';
    } else {
      return 'Text';
    }
  }
  
  // Dispose the controller
  void dispose() {
    controller.dispose();
  }
} 
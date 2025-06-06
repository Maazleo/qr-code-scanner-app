import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/qr_data.dart';

class QrGeneratorService {
  // Generate QR code widget
  Widget generateQrCode({
    required String data,
    required double size,
    Color backgroundColor = Colors.white,
    Color foregroundColor = Colors.black,
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      errorStateBuilder: (context, error) {
        return Container(
          width: size,
          height: size,
          color: backgroundColor,
          child: Center(
            child: Text(
              'Error generating QR code',
              style: TextStyle(color: foregroundColor),
            ),
          ),
        );
      },
    );
  }
  
  // Save QR code as image to user-selected location
  Future<String?> saveQrCodeImage(GlobalKey qrKey, String data) async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          return null; // Permission denied
        }
      }
      
      // Capture QR code as image
      final RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) return null;
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      // Let user select save location
      String? outputFile = await _getSaveLocation();
      if (outputFile == null) {
        return null; // User cancelled
      }
      
      // Create the file and write the bytes
      final File file = File(outputFile);
      await file.writeAsBytes(pngBytes);
      
      return outputFile;
    } catch (e) {
      print('Error saving QR code image: $e');
      return null;
    }
  }
  
  // Let user select save location
  Future<String?> _getSaveLocation() async {
    try {
      // Default filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String defaultFileName = 'qrcode_$timestamp.png';
      
      // Open file picker
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory == null) {
        return null; // User cancelled
      }
      
      // Return full path
      return '$selectedDirectory/$defaultFileName';
    } catch (e) {
      print('Error getting save location: $e');
      
      // Fallback to app documents directory
      final Directory directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'qrcode_$timestamp.png';
      return '${directory.path}/$fileName';
    }
  }
  
  // Create QR data object from input
  QrData createQrData(String data, {String? title}) {
    return QrData(
      data: data,
      type: _determineType(data),
      timestamp: DateTime.now(),
      title: title,
    );
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
} 
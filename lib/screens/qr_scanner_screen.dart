import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/qr_data.dart';
import '../services/qr_scanner_service.dart';
import '../services/storage_service.dart';
import '../services/url_launcher_service.dart';
import '../widgets/custom_button.dart';
import 'qr_result_screen.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final QrScannerService _scannerService = QrScannerService();
  final StorageService _storageService = StorageService();
  final UrlLauncherService _urlLauncherService = UrlLauncherService();
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _isScanning = true;

  @override
  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;
    
    setState(() {
      _isScanning = false;
    });
    
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty) {
      final QrData? qrData = _scannerService.processBarcode(barcodes.first);
      
      if (qrData != null) {
        // Save to history
        await _storageService.saveToHistory(qrData);
        
        // Navigate to result screen
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrResultScreen(qrData: qrData),
            ),
          ).then((_) {
            setState(() {
              _isScanning = true;
            });
          });
        }
      } else {
        setState(() {
          _isScanning = true;
        });
      }
    } else {
      setState(() {
        _isScanning = true;
      });
    }
  }

  Future<void> _scanFromGallery() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    final QrData? qrData = await _scannerService.scanFromGallery();
    
    // Hide loading indicator
    if (mounted) {
      Navigator.pop(context);
    }
    
    if (qrData != null && mounted) {
      // Save to history
      await _storageService.saveToHistory(qrData);
      
      // Navigate to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrResultScreen(qrData: qrData),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No QR code found in the image'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: _scannerService.controller,
            onDetect: _onDetect,
          ),
          
          // Overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Stack(
              children: [
                // Scanner cutout
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                    ),
                    child: const SizedBox(),
                  ),
                ),
                
                // Bottom controls
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Position the QR code within the frame',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Flash toggle
                            IconButton(
                              icon: Icon(
                                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFlashOn = !_isFlashOn;
                                  _scannerService.controller.toggleTorch();
                                });
                              },
                            ),
                            
                            // Gallery button
                            IconButton(
                              icon: const Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: _scanFromGallery,
                            ),
                            
                            // Camera toggle
                            IconButton(
                              icon: Icon(
                                _isFrontCamera
                                    ? Icons.camera_rear
                                    : Icons.camera_front,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFrontCamera = !_isFrontCamera;
                                  _scannerService.controller.switchCamera();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
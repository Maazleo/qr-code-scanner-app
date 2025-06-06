import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/qr_data.dart';
import '../services/qr_generator_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';

class QrGeneratorScreen extends ConsumerStatefulWidget {
  const QrGeneratorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends ConsumerState<QrGeneratorScreen> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final QrGeneratorService _generatorService = QrGeneratorService();
  final StorageService _storageService = StorageService();
  final GlobalKey _qrKey = GlobalKey();
  
  String _qrData = '';
  String _qrTitle = '';
  bool _isGenerated = false;
  String? _savedImagePath;
  
  @override
  void dispose() {
    _dataController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  
  void _generateQrCode() {
    final data = _dataController.text.trim();
    final title = _titleController.text.trim();
    
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some data'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    setState(() {
      _qrData = data;
      _qrTitle = title;
      _isGenerated = true;
      _savedImagePath = null; // Reset saved path when generating new QR code
    });
    
    // Save to history
    final qrData = _generatorService.createQrData(data, title: title.isNotEmpty ? title : null);
    _storageService.saveToHistory(qrData);
  }
  
  Future<void> _saveQrCode() async {
    if (!_isGenerated) return;
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    final filePath = await _generatorService.saveQrCodeImage(_qrKey, _qrData);
    
    // Hide loading indicator
    if (mounted) {
      Navigator.pop(context);
    }
    
    if (filePath != null && mounted) {
      setState(() {
        _savedImagePath = filePath;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR code saved successfully!'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              _showSavedImage(filePath);
            },
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      // User might have cancelled the save operation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code was not saved. You may have cancelled the operation or there was an error.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  void _showSavedImage(String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Saved QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(path),
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            Text('Saved to: $path'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _resetForm() {
    setState(() {
      _dataController.clear();
      _titleController.clear();
      _qrData = '';
      _qrTitle = '';
      _isGenerated = false;
      _savedImagePath = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        actions: [
          if (_isGenerated)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetForm,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isGenerated) ...[
                // Form
                Text(
                  'Create a QR Code',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the data you want to encode in the QR code',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title (Optional)',
                    hintText: 'Enter a title for this QR code',
                    prefixIcon: Icon(Icons.title),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dataController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    hintText: 'Enter URL, text, or other data',
                    prefixIcon: Icon(Icons.link),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _generateQrCode(),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Generate QR Code',
                  icon: Icons.qr_code,
                  onPressed: _generateQrCode,
                ),
              ] else ...[
                // Generated QR code
                Center(
                  child: Column(
                    children: [
                      if (_qrTitle.isNotEmpty) ...[
                        Text(
                          _qrTitle,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // QR code
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: RepaintBoundary(
                          key: _qrKey,
                          child: _generatorService.generateQrCode(
                            data: _qrData,
                            size: 250,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Data display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Content:',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _qrData,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Action buttons
                      CustomButton(
                        text: _savedImagePath != null ? 'QR Code Saved' : 'Save QR Code',
                        icon: _savedImagePath != null ? Icons.check : Icons.save_alt,
                        onPressed: _saveQrCode,
                        backgroundColor: _savedImagePath != null ? Colors.green : null,
                      ),
                      const SizedBox(height: 16),
                      if (_savedImagePath != null) ...[
                        CustomButton(
                          text: 'View Saved Image',
                          icon: Icons.image,
                          isOutlined: true,
                          onPressed: () => _showSavedImage(_savedImagePath!),
                        ),
                        const SizedBox(height: 16),
                      ],
                      CustomButton(
                        text: 'Share QR Code',
                        icon: Icons.share,
                        isOutlined: true,
                        onPressed: () {
                          // Share logic would go here
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Create New QR Code',
                        icon: Icons.add,
                        isOutlined: true,
                        onPressed: _resetForm,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 
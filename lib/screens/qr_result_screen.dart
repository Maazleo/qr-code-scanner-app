import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/qr_data.dart';
import '../services/url_launcher_service.dart';
import '../widgets/custom_button.dart';

class QrResultScreen extends ConsumerStatefulWidget {
  final QrData qrData;
  
  const QrResultScreen({
    Key? key,
    required this.qrData,
  }) : super(key: key);

  @override
  ConsumerState<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends ConsumerState<QrResultScreen> {
  final UrlLauncherService _urlLauncherService = UrlLauncherService();
  final TextEditingController _titleController = TextEditingController();
  bool _isEditing = false;
  
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
  
  // Get icon based on QR data type
  IconData _getTypeIcon() {
    switch (widget.qrData.type) {
      case 'URL':
        return Icons.link;
      case 'Email':
        return Icons.email;
      case 'Phone':
        return Icons.phone;
      default:
        return Icons.text_fields;
    }
  }

  // Get color based on QR data type
  Color _getTypeColor(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (widget.qrData.type) {
      case 'URL':
        return theme.colorScheme.primary;
      case 'Email':
        return theme.colorScheme.secondary;
      case 'Phone':
        return theme.colorScheme.tertiary;
      default:
        return Colors.grey;
    }
  }
  
  // Open the scanned content
  Future<void> _openContent() async {
    await _urlLauncherService.launchAppropriate(
      widget.qrData.data,
      widget.qrData.type,
    );
  }
  
  // Copy to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.qrData.data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getTypeIcon(),
                      size: 20,
                      color: typeColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.qrData.type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: typeColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title field
              if (_isEditing) ...[
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter a title for this QR code',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Save title logic would go here
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Text(
                      widget.qrData.title ?? 'No Title',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _titleController.text = widget.qrData.title ?? '';
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Content
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
                      widget.qrData.data,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action buttons
              CustomButton(
                text: 'Open Content',
                icon: Icons.open_in_new,
                onPressed: _openContent,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Copy to Clipboard',
                icon: Icons.content_copy,
                isOutlined: true,
                onPressed: _copyToClipboard,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Share',
                icon: Icons.share,
                isOutlined: true,
                onPressed: () {
                  // Share logic would go here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
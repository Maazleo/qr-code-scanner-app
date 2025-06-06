import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/qr_data.dart';

class HistoryItem extends StatelessWidget {
  final QrData qrData;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const HistoryItem({
    Key? key,
    required this.qrData,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    // Get icon based on QR data type
    IconData getTypeIcon() {
      switch (qrData.type) {
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
    Color getTypeColor() {
      switch (qrData.type) {
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type and timestamp
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getTypeIcon(),
                          size: 16,
                          color: getTypeColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          qrData.type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: getTypeColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(qrData.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: onDelete,
                      color: theme.colorScheme.error,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ],
                ],
              ),
              
              // Title or data preview
              const SizedBox(height: 12),
              Text(
                qrData.title ?? qrData.data,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Data preview if title is available
              if (qrData.title != null) ...[
                const SizedBox(height: 4),
                Text(
                  qrData.data,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 
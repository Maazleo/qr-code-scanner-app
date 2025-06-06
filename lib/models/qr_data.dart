import 'package:flutter/material.dart';

class QrData {
  final String data;
  final String type;
  final DateTime timestamp;
  final String? title;

  QrData({
    required this.data,
    required this.type,
    required this.timestamp,
    this.title,
  });

  factory QrData.fromJson(Map<String, dynamic> json) {
    return QrData(
      data: json['data'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'title': title,
    };
  }
} 
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_data.dart';

class StorageService {
  static const String _historyKey = 'qr_history';
  
  // Save QR code to history
  Future<bool> saveToHistory(QrData qrData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      // Convert QrData to JSON and add to history
      final qrDataJson = jsonEncode(qrData.toJson());
      
      // Check if this QR code already exists in history
      if (!historyJson.contains(qrDataJson)) {
        historyJson.insert(0, qrDataJson); // Add to beginning of list
        
        // Limit history to 100 items
        if (historyJson.length > 100) {
          historyJson.removeLast();
        }
        
        await prefs.setStringList(_historyKey, historyJson);
      }
      return true;
    } catch (e) {
      print('Error saving to history: $e');
      return false;
    }
  }
  
  // Get all QR codes from history
  Future<List<QrData>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      return historyJson.map((item) {
        final Map<String, dynamic> json = jsonDecode(item);
        return QrData.fromJson(json);
      }).toList();
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }
  
  // Clear all history
  Future<bool> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      return true;
    } catch (e) {
      print('Error clearing history: $e');
      return false;
    }
  }
  
  // Delete a specific QR code from history
  Future<bool> deleteFromHistory(QrData qrData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      final qrDataJson = jsonEncode(qrData.toJson());
      historyJson.remove(qrDataJson);
      
      await prefs.setStringList(_historyKey, historyJson);
      return true;
    } catch (e) {
      print('Error deleting from history: $e');
      return false;
    }
  }
} 
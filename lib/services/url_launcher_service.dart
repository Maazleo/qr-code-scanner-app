import 'package:url_launcher/url_launcher.dart' as url_launcher;

class UrlLauncherService {
  // Launch URL
  Future<bool> launchUrl(String url) async {
    try {
      // Add http:// prefix if missing
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      
      final Uri uri = Uri.parse(url);
      return await url_launcher.launchUrl(
        uri,
        mode: url_launcher.LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }
  
  // Launch email
  Future<bool> launchEmail(String email) async {
    try {
      final Uri uri = Uri(
        scheme: 'mailto',
        path: email,
      );
      return await url_launcher.launchUrl(uri);
    } catch (e) {
      print('Error launching email: $e');
      return false;
    }
  }
  
  // Launch phone call
  Future<bool> launchPhone(String phone) async {
    try {
      final Uri uri = Uri(
        scheme: 'tel',
        path: phone,
      );
      return await url_launcher.launchUrl(uri);
    } catch (e) {
      print('Error launching phone call: $e');
      return false;
    }
  }
  
  // Launch appropriate action based on data type
  Future<bool> launchAppropriate(String data, String type) async {
    switch (type) {
      case 'URL':
        return await launchUrl(data);
      case 'Email':
        return await launchEmail(data);
      case 'Phone':
        return await launchPhone(data);
      default:
        return false;
    }
  }
} 
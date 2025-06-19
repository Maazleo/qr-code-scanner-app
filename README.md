# QR Code Scanner & Generator
## Run and Use-> ## 🌐 Live Demo

[Click here to view the live site](https://qrscanandgenerator.netlify.app)

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
  <img src="https://img.shields.io/badge/Web-4285F4?style=for-the-badge&logo=Google-chrome&logoColor=white" alt="Web">
</div>

<div align="center">
  <h3>A powerful Flutter application for scanning and generating QR codes</h3>
</div>

---

## 📥 Download

<div align="center">
  <a href="https://github.com/Maazleo/qr-code-scanner-app/releases/download/v1.0.0/qr-code-scanner-app.apk">
    <img src="https://img.shields.io/badge/Download APK-4285F4?style=for-the-badge&logo=android&logoColor=white" alt="Download APK">
  </a>
</div>

> Note: You can download the latest APK from the [Releases](https://github.com/Maazleo/qr-code-scanner-app/releases) page.

---

## 📱 Features

### QR Code Scanning
- **Camera Scanning**: Scan QR codes in real-time using your device camera
- **Gallery Scanning**: Import and scan QR codes from your image gallery
- **Fast Detection**: Quick and accurate QR code detection
- **Multiple Formats**: Support for various QR code formats and data types

### QR Code Generation
- **Create Custom QR Codes**: Generate QR codes for:
  - URLs
  - Text
  - Email addresses
  - Phone numbers
  - And more!
- **Save Generated QR Codes**: Save QR codes to your preferred location
- **Customization Options**: Choose size and colors for your QR codes

### History & Management
- **Scan History**: Access all previously scanned QR codes
- **Organize**: Sort and filter your QR code history
- **Quick Actions**: Easily share or revisit scanned content

### User Experience
- **Modern UI**: Clean, intuitive interface with Material Design 3
- **Dark Mode Support**: Comfortable viewing in any lighting condition
- **Cross-Platform**: Works on Android, iOS, and Web

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version recommended)
- Android Studio / Xcode for mobile deployment
- Web browser for web deployment

### Installation

1. Clone this repository:
```bash
git clone https://github.com/Maazleo/qr-code-scanner-app.git
```

2. Navigate to the project folder:
```bash
cd qr-code-scanner-app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

---

## 📚 Libraries Used

- **mobile_scanner**: For QR code scanning using camera
- **qr_flutter**: For generating QR codes
- **image_picker**: For selecting images from gallery
- **shared_preferences**: For storing scan history
- **url_launcher**: For opening URLs from QR codes
- **file_picker**: For selecting where to save QR codes
- **google_fonts**: For beautiful typography
- **flutter_riverpod**: For state management

---

## 📋 Usage Guide

### Scanning a QR Code with Camera
1. Open the app and tap on "Scan QR Code"
2. Point your camera at the QR code
3. The app will automatically detect and process the QR code
4. View the result and take action (open URL, copy text, etc.)

### Scanning from Gallery
1. Tap on "Scan from Gallery"
2. Select an image containing a QR code
3. The app will process the image and extract QR code data

### Generating a QR Code
1. Tap on "Generate QR Code"
2. Enter the data you want to encode
3. Customize appearance if desired
4. Tap "Generate"
5. Save or share your QR code

### Viewing History
1. Tap on "History" to see all previously scanned codes
2. Tap any item to view details or re-use the data

---

## 🛠️ Technical Details

This app is built with Flutter, providing a cross-platform experience with a single codebase. It utilizes several key technologies:

- **State Management**: Flutter Riverpod for efficient state handling
- **Local Storage**: SharedPreferences for persistent data
- **Native Features**: Camera access, file system integration
- **UI Framework**: Material 3 design system

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Author

**Maaz Masroor**

- GitHub: [Maazleo](https://github.com/Maazleo)
- Portfolio: [Maaz Portfolio](https://maazmasroor-portfolio.netlify.app/)
- LinkedIn: [Muhammad Maaz](https://www.linkedin.com/in/muhammad-maaz-9b134a251)

---

<div align="center">
  <p>If you found this project helpful or interesting, please consider giving it a star! ⭐</p>
</div>

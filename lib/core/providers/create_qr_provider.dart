import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateQrProvider extends ChangeNotifier {
  String _generatedQrData = "";
  bool _isQrGenerated = false;

  String get generatedQrData => _generatedQrData;
  bool get isQrGenerated => _isQrGenerated;

  void reset() {
    _generatedQrData = "";
    _isQrGenerated = false;
    notifyListeners();
  }

  void generateUrlQr(String url) {
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      _generatedQrData = "https://$url";
    } else {
      _generatedQrData = url;
    }
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateTextQr(String text) {
    _generatedQrData = text;
    _isQrGenerated = true;
    notifyListeners();
  }

  void generatePhoneQr(String phone) {
    _generatedQrData = "tel:$phone";
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateEmailQr({
    required String to,
    required String subject,
    required String body,
  }) {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {'subject': subject, 'body': body},
    );
    _generatedQrData = uri.toString();
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateSmsQr({required String phone, required String message}) {
    _generatedQrData = "smsto:$phone:$message";
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateGeoQr({required String latitude, required String longitude}) {
    _generatedQrData = "geo:$latitude,$longitude";
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateWifiQr({
    required String ssid,
    required String password,
    required String security,
  }) {
    _generatedQrData = "WIFI:S:$ssid;T:$security;P:$password;;";
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateContactQr({
    required String name,
    required String phone,
    required String email,
    required String org,
    required String address,
    required String notes,
  }) {
    _generatedQrData =
        "BEGIN:VCARD\n"
        "VERSION:3.0\n"
        "FN:$name\n"
        "ORG:$org\n"
        "ADR:;;$address;;;;\n"
        "TEL:$phone\n"
        "EMAIL:$email\n"
        "NOTE:$notes\n"
        "END:VCARD";
    _isQrGenerated = true;
    notifyListeners();
  }

  void generateCalendarQr({
    required String title,
    required String location,
    required String description,
    required String start,
    required String end,
  }) {
    _generatedQrData =
        "BEGIN:VCALENDAR\n"
        "VERSION:2.0\n"
        "BEGIN:VEVENT\n"
        "SUMMARY:$title\n"
        "LOCATION:$location\n"
        "DESCRIPTION:$description\n"
        "DTSTART:$start\n"
        "DTEND:$end\n"
        "END:VEVENT\n"
        "END:VCALENDAR";
    _isQrGenerated = true;
    notifyListeners();
  }

  Future<bool> generateFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;
    if (text != null && text.isNotEmpty) {
      _generatedQrData = text;
      _isQrGenerated = true;
      notifyListeners();
      return true;
    }
    return false;
  }
}

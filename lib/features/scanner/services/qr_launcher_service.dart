import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QrLauncherService {
  static Future<void> launchQr({
    required BuildContext context,
    required String qrData,
  }) async {
    Uri? uri;

    if (qrData.startsWith("http://") || qrData.startsWith("https://")) {
      uri = Uri.parse(qrData);
    } else if (qrData.startsWith("mailto:")) {
      uri = Uri.parse(qrData);
    } else if (qrData.startsWith("tel:")) {
      uri = Uri.parse(qrData);
    } else if (qrData.startsWith("sms:")) {
      uri = Uri.parse(qrData);
    } else if (qrData.contains("wa.me") ||
        qrData.contains("api.whatsapp.com")) {
      uri = Uri.parse(qrData);
    } else if (qrData.startsWith("geo:") ||
        qrData.contains("maps.google.com") ||
        qrData.contains("google.com/maps")) {
      uri = Uri.parse(qrData);
    } else if (qrData.contains("youtube.com") || qrData.contains("youtu.be")) {
      uri = Uri.parse(qrData);
    } else if (qrData.contains("play.google.com/store/apps") ||
        qrData.startsWith("market://")) {
      uri = Uri.parse(qrData);
    } else if (qrData.startsWith("WIFI:")) {
      _showWifiDialog(context, qrData);
      return;
    }

    if (uri != null) {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint("Launched : $launched");
      return;
    }

    debugPrint("Unsupported QR : $qrData");
  }

  static void _showWifiDialog(BuildContext context, String wifiData) {
    String ssid = "";
    String password = "";
    String security = "";

    final data = wifiData.replaceFirst("WIFI:", "");

    final parts = data.split(";");

    for (final part in parts) {
      if (part.startsWith("S:")) {
        ssid = part.substring(2);
      } else if (part.startsWith("P:")) {
        password = part.substring(2);
      } else if (part.startsWith("T:")) {
        security = part.substring(2);
      }
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("WiFi Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SSID : $ssid"),
              const SizedBox(height: 8),
              Text("Password : $password"),
              const SizedBox(height: 8),
              Text("Security : $security"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

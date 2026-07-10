import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/my_qr_provider.dart';
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
      _showWiFiDialog(context, qrData);
      return;
    } else if (qrData.startsWith("BEGIN:VCARD") ||
        qrData.contains("BEGIN:VCARD")) {
      _showVCardDialog(context, qrData);
      return;
    }

    if (uri != null) {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      _showPlainTextDialog(context, qrData);
    }
  }

  static void _showWiFiDialog(BuildContext context, String wifiData) {
    String ssid = "";
    String password = "";
    String security = "";

    // Regex parsing
    final ssidReg = RegExp(r'S:([^;]+);');
    final passReg = RegExp(r'P:([^;]+);');
    final secReg = RegExp(r'T:([^;]+);');

    final ssidMatch = ssidReg.firstMatch(wifiData);
    if (ssidMatch != null) ssid = ssidMatch.group(1) ?? "";

    final passMatch = passReg.firstMatch(wifiData);
    if (passMatch != null) password = passMatch.group(1) ?? "";

    final secMatch = secReg.firstMatch(wifiData);
    if (secMatch != null) {
      security = secMatch.group(1) ?? "";
      if (security.isEmpty) {
        security = "None";
      }
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(AppStrings.wifiInformation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${AppStrings.ssidLabel} : $ssid"),
              const SizedBox(height: 8),
              Text("${AppStrings.passwordLabel} : $password"),
              const SizedBox(height: 8),
              Text("${AppStrings.securityLabel} : $security"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.okText),
            ),
          ],
        );
      },
    );
  }

  static void _showVCardDialog(BuildContext context, String vCardData) {
    try {
      final contacts = FlutterContacts.vCard.import(vCardData);
      if (contacts.isEmpty) {
        _showPlainTextDialog(context, vCardData);
        return;
      }
      final contact = contacts.first;

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(AppStrings.contactInformation),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact.displayName != null && contact.displayName!.isNotEmpty) ...[
                    Text("${AppStrings.nameColon}${contact.displayName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                  ],
                  if (contact.phones.isNotEmpty) ...[
                    Text("${AppStrings.phoneColon}${contact.phones.first.number}"),
                    const SizedBox(height: 8),
                  ],
                  if (contact.emails.isNotEmpty) ...[
                    Text("${AppStrings.emailColon}${contact.emails.first.address}"),
                    const SizedBox(height: 8),
                  ],
                  if (contact.addresses.isNotEmpty) ...[
                    Text("${AppStrings.addressColon}${contact.addresses.first.formatted ?? ""}"),
                    const SizedBox(height: 8),
                  ],
                  if (contact.organizations.isNotEmpty) ...[
                    Text("${AppStrings.companyColon}${contact.organizations.first.name ?? ""}"),
                    const SizedBox(height: 8),
                  ],
                  if (contact.notes.isNotEmpty) ...[
                    Text("${AppStrings.notesColon}${contact.notes.first.note}"),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<MyQrProvider>().importFromContact(contact);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AppStrings.importedSuccessMessage)),
                  );
                  Navigator.pushReplacementNamed(context, "/my_qr");
                },
                child: const Text(AppStrings.setAsMyQr),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  final status = await Permission.contacts.request();
                  if (status.isGranted) {
                    try {
                      await FlutterContacts.native.showCreator(contact: contact);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${AppStrings.couldNotOpenContactCreatorError}: $e")),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppStrings.contactPermissionRequired)),
                      );
                    }
                  }
                },
                child: const Text(AppStrings.saveToContacts),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(AppStrings.cancelText),
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showPlainTextDialog(context, vCardData);
    }
  }

  static void _showPlainTextDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.scannedResult),
          content: SingleChildScrollView(
            child: Text(text),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.copiedToClipboard)),
                );
              },
              child: const Text(AppStrings.copyText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(AppStrings.okText),
            ),
          ],
        );
      },
    );
  }
}

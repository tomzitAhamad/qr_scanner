import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/my_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class QrLauncherService {
  static Future<void> launchQr({
    required BuildContext context,
    required String qrData,
  }) async {
    final settings = context.read<SettingsProvider>();
    final isWebUrl =
        qrData.startsWith("http://") || qrData.startsWith("https://");

    if (isWebUrl) {
      if (settings.urlInfo) {
        await _showUrlInfoDialog(context, qrData);
        return;
      } else {
        await launchUrl(
          Uri.parse(qrData),
          mode: LaunchMode.externalApplication,
        );
        return;
      }
    }

    Uri? uri;

    if (qrData.startsWith("mailto:")) {
      if (settings.urlInfo) {
        await _showEmailDialog(context, qrData);
        return;
      } else {
        uri = Uri.parse(qrData);
      }
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
      if (settings.urlInfo) {
        await _showWiFiDialog(context, qrData);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("WiFi Scan: $qrData"),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
      return;
    } else if (qrData.startsWith("BEGIN:VCARD") ||
        qrData.contains("BEGIN:VCARD")) {
      if (settings.urlInfo) {
        await _showVCardDialog(context, qrData);
      } else {
        try {
          final contacts = FlutterContacts.vCard.import(qrData);
          if (contacts.isNotEmpty) {
            final contact = contacts.first;
            final status = await Permission.contacts.request();
            if (status.isGranted) {
              await FlutterContacts.native.showCreator(contact: contact);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Contact permission required to save"),
                  ),
                );
              }
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Contact details: $qrData")),
              );
            }
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Scanned: $qrData")),
            );
          }
        }
      }
      return;
    }

    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (settings.urlInfo) {
        await _showPlainTextDialog(context, qrData);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Scanned: $qrData"),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  static Future<void> _showWiFiDialog(BuildContext context, String wifiData) async {
    String ssid = "";
    String password = "";
    String security = "";
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

    await showDialog(
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

  static Future<void> _showVCardDialog(BuildContext context, String vCardData) async {
    try {
      final contacts = FlutterContacts.vCard.import(vCardData);
      if (contacts.isEmpty) {
        await _showPlainTextDialog(context, vCardData);
        return;
      }
      final contact = contacts.first;

      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(AppStrings.contactInformation),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact.displayName != null &&
                      contact.displayName!.isNotEmpty) ...[
                    Text(
                      "${AppStrings.nameColon}${contact.displayName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (contact.phones.isNotEmpty) ...[
                    Text(
                      "${AppStrings.phoneColon}${contact.phones.first.number}",
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (contact.emails.isNotEmpty) ...[
                    Text(
                      "${AppStrings.emailColon}${contact.emails.first.address}",
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (contact.addresses.isNotEmpty) ...[
                    Text(
                      "${AppStrings.addressColon}${contact.addresses.first.formatted ?? ""}",
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (contact.organizations.isNotEmpty) ...[
                    Text(
                      "${AppStrings.companyColon}${contact.organizations.first.name ?? ""}",
                    ),
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
                    const SnackBar(
                      content: Text(AppStrings.importedSuccessMessage),
                    ),
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
                      await FlutterContacts.native.showCreator(
                        contact: contact,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${AppStrings.couldNotOpenContactCreatorError}: $e",
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.contactPermissionRequired),
                        ),
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
      if (!context.mounted) return;
      await _showPlainTextDialog(context, vCardData);
    }
  }

  static Future<void> _showEmailDialog(BuildContext context, String emailData) async {
    final emailUri = Uri.parse(emailData);
    final emailAddress = emailUri.path;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Email Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Would you like to send an email to?"),
              const SizedBox(height: 12),
              Text(
                emailAddress,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(AppStrings.cancelText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Clipboard.setData(ClipboardData(text: emailAddress));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.copiedToClipboard)),
                );
              },
              child: const Text(AppStrings.copyText),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await launchUrl(emailUri, mode: LaunchMode.externalApplication);
              },
              child: const Text("Send Email"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _showPlainTextDialog(BuildContext context, String text) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.scannedResult),
          content: SingleChildScrollView(child: Text(text)),
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

  static Future<void> _showUrlInfoDialog(BuildContext context, String urlString) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _UrlInfoDialog(urlString: urlString, parentContext: context);
      },
    );
  }
}

class _UrlInfoDialog extends StatefulWidget {
  final String urlString;
  final BuildContext parentContext;

  const _UrlInfoDialog({required this.urlString, required this.parentContext});

  @override
  State<_UrlInfoDialog> createState() => _UrlInfoDialogState();
}

class _UrlInfoDialogState extends State<_UrlInfoDialog> {
  bool _isLoading = true;
  String _title = '';
  String _description = '';
  String _host = '';

  @override
  void initState() {
    super.initState();
    try {
      _host = Uri.parse(widget.urlString).host;
    } catch (_) {
      _host = '';
    }
    _fetchMetadata();
  }

  Future<void> _fetchMetadata() async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);
    try {
      final request = await client.getUrl(Uri.parse(widget.urlString));
      request.headers.set(
        'user-agent',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
      );
      final response = await request.close();
      if (response.statusCode == 200) {
        final contentType = response.headers.contentType?.toString() ?? '';
        if (contentType.contains('text/html')) {
          final bytesBuilder = BytesBuilder();
          int bytesRead = 0;
          await for (final chunk in response) {
            bytesBuilder.add(chunk);
            bytesRead += chunk.length;
            if (bytesRead > 102400) break; // 100KB limit
          }
          final contents = utf8.decode(
            bytesBuilder.toBytes(),
            allowMalformed: true,
          );

          String parsedTitle = '';
          String parsedDesc = '';

          // Open Graph title
          final ogTitleMatch = RegExp(
            r'''<meta\s+[^>]*property=["']og:title["']\s+content=["']([^"']*)["']''',
            caseSensitive: false,
          ).firstMatch(contents);
          if (ogTitleMatch != null) {
            parsedTitle = ogTitleMatch.group(1) ?? '';
          }
          if (parsedTitle.isEmpty) {
            final titleMatch = RegExp(
              r'''<title>(.*?)</title>''',
              caseSensitive: false,
              dotAll: true,
            ).firstMatch(contents);
            if (titleMatch != null) {
              parsedTitle = titleMatch.group(1) ?? '';
            }
          }

          // Open Graph description
          final ogDescMatch = RegExp(
            r'''<meta\s+[^>]*property=["']og:description["']\s+content=["']([^"']*)["']''',
            caseSensitive: false,
          ).firstMatch(contents);
          if (ogDescMatch != null) {
            parsedDesc = ogDescMatch.group(1) ?? '';
          }
          if (parsedDesc.isEmpty) {
            final descMatch = RegExp(
              r'''<meta\s+[^>]*name=["']description["']\s+content=["']([^"']*)["']''',
              caseSensitive: false,
              dotAll: true,
            ).firstMatch(contents);
            if (descMatch != null) {
              parsedDesc = descMatch.group(1) ?? '';
            }
          }
          if (parsedDesc.isEmpty) {
            final descMatchAlt = RegExp(
              r'''<meta\s+[^>]*content=["']([^"']*)["']\s+name=["']description["']''',
              caseSensitive: false,
              dotAll: true,
            ).firstMatch(contents);
            if (descMatchAlt != null) {
              parsedDesc = descMatchAlt.group(1) ?? '';
            }
          }

          if (mounted) {
            setState(() {
              _title = parsedTitle.trim();
              _description = parsedDesc.trim();
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {
      // ignore, load with default fallback
    } finally {
      client.close();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedTitle = _title.isNotEmpty ? _title : 'Website Preview';
    final displayedDesc = _description.isNotEmpty
        ? _description
        : 'No website description available.';

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.language, color: theme.primaryColor),
          const SizedBox(width: 8),
          const Text("Website Info"),
        ],
      ),
      content: _isLoading
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Retrieving page information...",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_host.isNotEmpty) ...[
                  Text(
                    _host,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  displayedTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  displayedDesc,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.urlString,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: widget.urlString));
            ScaffoldMessenger.of(widget.parentContext).showSnackBar(
              const SnackBar(content: Text(AppStrings.copiedToClipboard)),
            );
          },
          child: const Text(AppStrings.copyText),
        ),
        if (!_isLoading)
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final uri = Uri.parse(widget.urlString);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: const Text("Open Link"),
          ),
      ],
    );
  }
}

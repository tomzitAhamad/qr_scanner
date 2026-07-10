import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/create_qr_provider.dart';
import '../../../../core/widgets/app_drawer.dart';

class CreateQrPage extends StatelessWidget {
  const CreateQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        "icon": Icons.assignment_outlined,
        "title": "Content from clipboard",
        "type": "clipboard",
      },
      {
        "icon": Icons.link,
        "title": "URL",
        "type": "url",
      },
      {
        "icon": Icons.text_fields_outlined,
        "title": "Text",
        "type": "text",
      },
      {
        "icon": Icons.person_outline,
        "title": "Contact",
        "type": "contact",
      },
      {
        "icon": Icons.email_outlined,
        "title": "Email",
        "type": "email",
      },
      {
        "icon": Icons.sms_outlined,
        "title": "SMS",
        "type": "sms",
      },
      {
        "icon": Icons.location_on_outlined,
        "title": "Geo",
        "type": "geo",
      },
      {
        "icon": Icons.phone_outlined,
        "title": "Phone",
        "type": "phone",
      },
      {
        "icon": Icons.calendar_month_outlined,
        "title": "Calendar",
        "type": "calendar",
      },
      {
        "icon": Icons.wifi,
        "title": "Wifi",
        "type": "wifi",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create"),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                "Create QR",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white10,
                  height: 1,
                  indent: 52,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  return ListTile(
                    leading: Icon(
                      option['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                    title: Text(
                      option['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      final type = option['type'] as String;
                      final title = option['title'] as String;

                      if (type == "clipboard") {
                        final provider = context.read<CreateQrProvider>();
                        final success = await provider.generateFromClipboard();
                        if (success) {
                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              "/create_qr/form",
                              arguments: {
                                "type": "clipboard_success",
                                "title": "Clipboard Contents",
                              },
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Clipboard is empty or doesn't contain text!"),
                              ),
                            );
                          }
                        }
                      } else {
                        Navigator.pushNamed(
                          context,
                          "/create_qr/form",
                          arguments: {
                            "type": type,
                            "title": title,
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

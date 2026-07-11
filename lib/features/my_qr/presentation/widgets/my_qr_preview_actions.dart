import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers/my_qr_provider.dart';

class MyQrPreviewActions extends StatelessWidget {
  final MyQrProvider myQrProvider;

  const MyQrPreviewActions({super.key, required this.myQrProvider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _GridButton(
                  icon: Icons.person_add_alt_1_outlined,
                  label: AppStrings.addContact,
                  onTap: () async {
                    final status = await Permission.contacts.request();
                    if (status.isGranted) {
                      try {
                        final contact = Contact(
                          name: Name(first: myQrProvider.fullName),
                          phones: [
                            Phone(number: myQrProvider.phoneNumber),
                          ],
                          emails: [
                            Email(address: myQrProvider.email),
                          ],
                          addresses: [
                            Address(
                              formatted: myQrProvider.address,
                            ),
                          ],
                          organizations: [
                            Organization(
                              name: myQrProvider.organization,
                            ),
                          ],
                          notes: [Note(note: myQrProvider.notes)],
                        );
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
                    }
                  },
                ),
              ),
              Expanded(
                child: _GridButton(
                  icon: Icons.location_on_outlined,
                  label: AppStrings.showMap,
                  onTap: () async {
                    if (myQrProvider.address.isNotEmpty) {
                      final url = Uri.parse(
                        "geo:0,0?q=${Uri.encodeComponent(myQrProvider.address)}",
                      );
                      await launchUrl(url);
                    }
                  },
                ),
              ),
              Expanded(
                child: _GridButton(
                  icon: Icons.phone_outlined,
                  label: AppStrings.call,
                  onTap: () async {
                    if (myQrProvider.phoneNumber.isNotEmpty) {
                      final url = Uri.parse(
                        "tel:${myQrProvider.phoneNumber}",
                      );
                      await launchUrl(url);
                    }
                  },
                ),
              ),
              Expanded(
                child: _GridButton(
                  icon: Icons.email_outlined,
                  label: AppStrings.sendEmail,
                  onTap: () async {
                    if (myQrProvider.email.isNotEmpty) {
                      final url = Uri.parse(
                        "mailto:${myQrProvider.email}",
                      );
                      await launchUrl(url);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: _GridButton(
                  icon: Icons.share_outlined,
                  label: AppStrings.share,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: myQrProvider.generatedQrCodeData ?? "",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.vCardCopiedToShare),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _GridButton(
                  icon: Icons.copy_outlined,
                  label: AppStrings.copy,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: myQrProvider.generatedQrCodeData ?? "",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.copiedToClipboard),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GridButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.accentBlue, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

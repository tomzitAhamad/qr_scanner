import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers/my_qr_provider.dart';

class MyQrDisplayView extends StatelessWidget {
  const MyQrDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    final myQrProvider = context.watch<MyQrProvider>();
    final qrData = myQrProvider.generatedQrCodeData ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 220.0,
                  foregroundColor: Colors.black,
                  gapless: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          OutlinedButton(
            onPressed: () {
              _showPreviewDialog(context, myQrProvider);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_outlined, size: 18),
                SizedBox(width: 8),
                Text(AppStrings.scanLayoutPreview),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.contactDetails,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 12),

                  if (myQrProvider.fullName.isNotEmpty)
                    _buildDetailRow(
                      Icons.person_outline,
                      AppStrings.fullNameLabel,
                      myQrProvider.fullName,
                    ),
                  if (myQrProvider.phoneNumber.isNotEmpty)
                    _buildDetailRow(
                      Icons.phone_outlined,
                      AppStrings.phoneNumberLabel,
                      myQrProvider.phoneNumber,
                    ),
                  if (myQrProvider.organization.isNotEmpty)
                    _buildDetailRow(
                      Icons.business_outlined,
                      AppStrings.orgLabel,
                      myQrProvider.organization,
                    ),
                  if (myQrProvider.email.isNotEmpty)
                    _buildDetailRow(
                      Icons.email_outlined,
                      AppStrings.emailLabel,
                      myQrProvider.email,
                    ),
                  if (myQrProvider.address.isNotEmpty)
                    _buildDetailRow(
                      Icons.location_on_outlined,
                      AppStrings.addressLabel,
                      myQrProvider.address,
                    ),
                  if (myQrProvider.notes.isNotEmpty)
                    _buildDetailRow(
                      Icons.note_alt_outlined,
                      AppStrings.notesLabel,
                      myQrProvider.notes,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    myQrProvider.editQrCode();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(AppStrings.editInfo),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    myQrProvider.clearQrCode();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, size: 18),
                      SizedBox(width: 8),
                      Text(AppStrings.deleteQr),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, MyQrProvider myQrProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.blueAccent,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.contactTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              AppStrings.scannedContactCardPreview,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.star_outline,
                          color: Colors.white54,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (myQrProvider.fullName.isNotEmpty)
                        Text(
                          myQrProvider.fullName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (myQrProvider.organization.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          myQrProvider.organization,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                      if (myQrProvider.address.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          myQrProvider.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                      if (myQrProvider.phoneNumber.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          myQrProvider.phoneNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                      if (myQrProvider.email.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          myQrProvider.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                      if (myQrProvider.notes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          myQrProvider.notes,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Padding(
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
                            child: _buildGridButton(
                              icon: Icons.person_add_alt_1_outlined,
                              label: AppStrings.addContact,
                              onTap: () async {
                                final status = await Permission.contacts
                                    .request();
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                            child: _buildGridButton(
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
                            child: _buildGridButton(
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
                            child: _buildGridButton(
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
                            child: _buildGridButton(
                              icon: Icons.share_outlined,
                              label: AppStrings.share,
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        myQrProvider.generatedQrCodeData ?? "",
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
                            child: _buildGridButton(
                              icon: Icons.copy_outlined,
                              label: AppStrings.copy,
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        myQrProvider.generatedQrCodeData ?? "",
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
                ),
                const Divider(color: Colors.white12, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: QrImageView(
                          data: myQrProvider.generatedQrCodeData ?? "",
                          version: QrVersions.auto,
                          size: 140.0,
                          foregroundColor: Colors.black,
                          gapless: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(AppStrings.closePreview),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
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
                color: const Color(0xFF2563EB).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF2563EB), size: 24),
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

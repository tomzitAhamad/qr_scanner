import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';
import 'package:qr_code_scanner/core/providers/responsive_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/providers/my_qr_provider.dart';
import 'detail_row.dart';
import 'my_qr_preview_dialog.dart';

class MyQrDisplayView extends StatelessWidget {
  const MyQrDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    final myQrProvider = context.watch<MyQrProvider>();
    final qrData = myQrProvider.generatedQrCodeData ?? "";
    final responsive = context.watch<ResponsiveProvider>();
    final theme = Theme.of(context);

    Widget qrColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Card(
              color: AppColors.white,
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
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.black,
                  ),
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
        ],
      );
    }

    Widget detailsColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.contactDetails,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  if (myQrProvider.fullName.isNotEmpty)
                    DetailRow(
                      icon: Icons.person_outline,
                      label: AppStrings.fullNameLabel,
                      value: myQrProvider.fullName,
                    ),
                  if (myQrProvider.phoneNumber.isNotEmpty)
                    DetailRow(
                      icon: Icons.phone_outlined,
                      label: AppStrings.phoneNumberLabel,
                      value: myQrProvider.phoneNumber,
                    ),
                  if (myQrProvider.organization.isNotEmpty)
                    DetailRow(
                      icon: Icons.business_outlined,
                      label: AppStrings.orgLabel,
                      value: myQrProvider.organization,
                    ),
                  if (myQrProvider.email.isNotEmpty)
                    DetailRow(
                      icon: Icons.email_outlined,
                      label: AppStrings.emailLabel,
                      value: myQrProvider.email,
                    ),
                  if (myQrProvider.address.isNotEmpty)
                    DetailRow(
                      icon: Icons.location_on_outlined,
                      label: AppStrings.addressLabel,
                      value: myQrProvider.address,
                    ),
                  if (myQrProvider.notes.isNotEmpty)
                    DetailRow(
                      icon: Icons.note_alt_outlined,
                      label: AppStrings.notesLabel,
                      value: myQrProvider.notes,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                    backgroundColor: AppColors.deleteColor,
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
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: responsive.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                qrColumn(),
                const SizedBox(height: 24),
                detailsColumn(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: qrColumn()),
                const SizedBox(width: 24),
                Expanded(flex: 3, child: detailsColumn()),
              ],
            ),
    );
  }

  void _showPreviewDialog(BuildContext context, MyQrProvider myQrProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MyQrPreviewDialog(myQrProvider: myQrProvider);
      },
    );
  }
}

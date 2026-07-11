import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';
import 'package:qr_code_scanner/core/widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .72,
      color: AppColors.drawerBg,
      child: SafeArea(
        child: Column(
          children: [
            DrawerItem(
              icon: Icons.qr_code_scanner,
              title: AppStrings.scanString,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/");
              },
            ),

            DrawerItem(
              icon: Icons.image_outlined,
              title: AppStrings.scanImageString,
              onTap: () {
                final scaffoldContext = Scaffold.of(context).context;
                Navigator.pop(context);
                scaffoldContext.read<ScannerProvider>().scanImage(scaffoldContext);
              },
            ),

            DrawerItem(
              icon: Icons.favorite_border,
              title: AppStrings.favoriteString,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/favorite");
              },
            ),

            DrawerItem(
              icon: Icons.history,
              title: AppStrings.historyString,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/history");
              },
            ),

            DrawerItem(
              icon: Icons.badge_outlined,
              title: AppStrings.myQrString,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/my_qr");
              },
            ),

            DrawerItem(
              icon: Icons.edit_outlined,
              title: AppStrings.createQrString,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/create_qr");
              },
            ),

            DrawerItem(
              icon: Icons.settings_outlined,
              title: AppStrings.settingsString,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/settings");
              },
            ),

            DrawerItem(
              icon: Icons.share_outlined,
              title: AppStrings.shareString,
              onTap: () {
                Navigator.pop(context);
                context.read<SettingsProvider>().shareApp();
              },
            ),

            DrawerItem(
              icon: Icons.apps_outlined,
              title: AppStrings.ourAppsString,
              onTap: () {
                Navigator.pop(context);
                // TODO: Open Play Store
              },
            ),

            DrawerItem(
              icon: Icons.block_outlined,
              title: AppStrings.removeAdsString,
              onTap: () {
                Navigator.pop(context);
                // TODO: Remove Ads
              },
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';
import 'package:qr_code_scanner/core/widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .72,
      color: const Color(0xff2C2C2C),
      child: SafeArea(
        child: Column(
          children: [
            DrawerItem(
              icon: Icons.qr_code_scanner,
              title: "Scan",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/");
              },
            ),

            DrawerItem(
              icon: Icons.image_outlined,
              title: "Scan Image",
              onTap: () {
                Navigator.pop(context);
                context.read<ScannerProvider>().scanImage(context);
              },
            ),

            DrawerItem(
              icon: Icons.favorite_border,
              title: "Favorites",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/favorite");
              },
            ),

            DrawerItem(
              icon: Icons.history,
              title: "History",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/history");
              },
            ),

            DrawerItem(
              icon: Icons.badge_outlined,
              title: "My QR",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/my_qr");
              },
            ),

            DrawerItem(
              icon: Icons.edit_outlined,
              title: "Create QR",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/create_qr");
              },
            ),

            DrawerItem(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/settings");
              },
            ),

            DrawerItem(
              icon: Icons.share_outlined,
              title: "Share",
              onTap: () {
                Navigator.pop(context);
                // TODO: Share App
              },
            ),

            DrawerItem(
              icon: Icons.apps_outlined,
              title: "Our Apps",
              onTap: () {
                Navigator.pop(context);
                // TODO: Open Play Store
              },
            ),

            DrawerItem(
              icon: Icons.block_outlined,
              title: "Remove Ads",
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


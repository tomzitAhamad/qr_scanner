import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_code_scanner/core/providers/navigation_provider.dart';
import 'package:qr_code_scanner/features/create_qr/presentation/pages/create_qr_page.dart';
import 'package:qr_code_scanner/features/favorites/presentation/pages/favorite_page.dart';
import 'package:qr_code_scanner/features/history/presentation/pages/history_page.dart';
import 'package:qr_code_scanner/features/my_qr/presentation/pages/my_qr_page.dart';
import 'package:qr_code_scanner/features/scanner/presentation/pages/scanner_page.dart';
import 'package:qr_code_scanner/features/settings/presentation/pages/settings_page.dart';
import 'drawer_item.dart';

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
                context.read<NavigationProvider>().closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScannerPage()),
                );
              },
            ),

            DrawerItem(
              icon: Icons.image_outlined,
              title: "Scan Image",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                // TODO: Navigate to Scan Image page
              },
            ),

            DrawerItem(
              icon: Icons.favorite_border,
              title: "Favorites",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritePage()),
                );
              },
            ),

            DrawerItem(
              icon: Icons.history,
              title: "History",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                );
              },
            ),

            DrawerItem(
              icon: Icons.badge_outlined,
              title: "My QR",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyQrPage()),
                );
              },
            ),

            DrawerItem(
              icon: Icons.edit_outlined,
              title: "Create QR",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateQrPage()),
                );
              },
            ),

            DrawerItem(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),

            DrawerItem(
              icon: Icons.share_outlined,
              title: "Share",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                // TODO: Share App
              },
            ),

            DrawerItem(
              icon: Icons.apps_outlined,
              title: "Our Apps",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                // TODO: Open Play Store
              },
            ),

            DrawerItem(
              icon: Icons.block_outlined,
              title: "Remove Ads",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                // TODO: Remove Ads
              },
            ),
          ],
        ),
      ),
    );
  }
}

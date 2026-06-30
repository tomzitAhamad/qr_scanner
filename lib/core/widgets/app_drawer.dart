import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/widgets/drawer_item.dart';

import '../providers/navigation_provider.dart';

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
                Navigator.pushNamed(context, "/");
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
                Navigator.pushNamed(context, "/favorite");
              },
            ),

            DrawerItem(
              icon: Icons.history,
              title: "History",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.pushNamed(context, "/history");
              },
            ),

            DrawerItem(
              icon: Icons.badge_outlined,
              title: "My QR",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.pushNamed(context, "/my_qr");
              },
            ),

            DrawerItem(
              icon: Icons.edit_outlined,
              title: "Create QR",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.pushNamed(context, "/create_qr");
              },
            ),

            DrawerItem(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {
                context.read<NavigationProvider>().closeDrawer();
                Navigator.pushNamed(context, "/settings");
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

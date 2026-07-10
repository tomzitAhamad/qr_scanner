import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import '../../../../core/widgets/app_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsString),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: const Center(child: Text(AppStrings.settingsPageTitle)),
    );
  }
}

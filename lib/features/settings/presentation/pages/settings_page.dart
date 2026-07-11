import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/color_scheme_selector.dart';
import '../widgets/setting_toggle_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppStrings.themeLight;
      case ThemeMode.dark:
        return AppStrings.themeDark;
      case ThemeMode.system:
        return AppStrings.themeSystem;
    }
  }

  void _showThemeDialog(BuildContext context, SettingsProvider settings) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(AppStrings.themeLabel),
          content: RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                settings.setThemeMode(mode);
                Navigator.of(ctx).pop();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text(AppStrings.themeLight),
                  value: ThemeMode.light,
                  activeColor: theme.primaryColor,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text(AppStrings.themeDark),
                  value: ThemeMode.dark,
                  activeColor: theme.primaryColor,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text(AppStrings.themeSystem),
                  value: ThemeMode.system,
                  activeColor: theme.primaryColor,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(AppStrings.cancelText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsString),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ColorSchemeSelector(settings: settings),

          const Divider(height: 24, thickness: 1),
          ListTile(
            title: Text(
              AppStrings.themeLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _getThemeModeName(settings.themeMode),
              style: theme.textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _showThemeDialog(context, settings),
          ),

          const Divider(height: 24, thickness: 1),
          SettingToggleTile(
            title: AppStrings.beepLabel,
            value: settings.beep,
            onChanged: (val) => settings.setBeep(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.vibrateLabel,
            value: settings.vibrate,
            onChanged: (val) => settings.setVibrate(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.copyToClipboardLabel,
            value: settings.copyToClipboard,
            onChanged: (val) => settings.setCopyToClipboard(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.urlInfoLabel,
            subtitle: AppStrings.urlInfoDesc,
            value: settings.urlInfo,
            onChanged: (val) => settings.setUrlInfo(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.batchScanLabel,
            subtitle: AppStrings.batchScanDesc,
            value: settings.batchScanMode,
            onChanged: (val) => settings.setBatchScanMode(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.autoFocusLabel,
            value: settings.useAutoFocus,
            onChanged: (val) => settings.setUseAutoFocus(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.touchFocusLabel,
            subtitle: AppStrings.touchFocusDesc,
            value: settings.touchFocus,
            onChanged: settings.useAutoFocus
                ? (val) => settings.setTouchFocus(val ?? false)
                : null,
          ),
          SettingToggleTile(
            title: AppStrings.keepDuplicatesLabel,
            value: settings.keepDuplicates,
            onChanged: (val) => settings.setKeepDuplicates(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.customActionLabel,
            subtitle: AppStrings.customActionDesc,
            value: settings.customAction,
            onChanged: (val) => settings.setCustomAction(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.inAppBrowserLabel,
            value: settings.useInAppBrowser,
            onChanged: (val) => settings.setUseInAppBrowser(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.addHistoryLabel,
            value: settings.addScansToHistory,
            onChanged: (val) => settings.setAddScansToHistory(val ?? false),
          ),
          SettingToggleTile(
            title: AppStrings.autoOpenUrlsLabel,
            subtitle: AppStrings.autoOpenUrlsDesc,
            value: settings.automaticallyOpenUrls,
            onChanged: (val) => settings.setAutomaticallyOpenUrls(val ?? false),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}



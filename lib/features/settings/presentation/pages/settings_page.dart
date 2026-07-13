import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/color_scheme_selector.dart';
import '../widgets/setting_toggle_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showCustomUrlDialog(BuildContext context, SettingsProvider settings) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: settings.customActionUrl);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(AppStrings.setCustomActionFilterTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: AppStrings.customActionFilterDialogHint,
                  labelText: AppStrings.customActionFilterDialogLabel,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.customActionFilterDialogDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(AppStrings.cancelText),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                settings.setCustomActionUrl(controller.text.trim());
                Navigator.of(ctx).pop();
              },
              child: const Text(
                AppStrings.okText,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

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
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsString),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          ColorSchemeSelector(settings: settings),
          const Divider(height: 1, thickness: 1),
          _ThemeTile(
            name: _getThemeModeName(settings.themeMode),
            onTap: () => _showThemeDialog(context, settings),
          ),
          const Divider(height: 1, thickness: 1),
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
            title: AppStrings.customActionLabel,
            subtitle: AppStrings.customActionDesc,
            value: settings.customAction,
            onChanged: (val) => settings.setCustomAction(val ?? false),
          ),
          if (settings.customAction) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 26),
              title: const Text(
                AppStrings.customActionFilterLabel,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                settings.customActionUrl.isEmpty
                    ? AppStrings.customActionFilterHint
                    : settings.customActionUrl,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
              ),
              trailing: const Icon(Icons.edit_outlined, size: 22),
              onTap: () => _showCustomUrlDialog(context, settings),
            ),
            const Divider(height: 1, thickness: 1),
          ],

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

class _ThemeTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _ThemeTile({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.themeLabel,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 17),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

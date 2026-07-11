import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import '../../../../core/widgets/app_drawer.dart';

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
          _ColorSchemeSelector(settings: settings),

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
          _SettingToggleTile(
            title: AppStrings.beepLabel,
            value: settings.beep,
            onChanged: (val) => settings.setBeep(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.vibrateLabel,
            value: settings.vibrate,
            onChanged: (val) => settings.setVibrate(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.copyToClipboardLabel,
            value: settings.copyToClipboard,
            onChanged: (val) => settings.setCopyToClipboard(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.urlInfoLabel,
            subtitle: AppStrings.urlInfoDesc,
            value: settings.urlInfo,
            onChanged: (val) => settings.setUrlInfo(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.batchScanLabel,
            subtitle: AppStrings.batchScanDesc,
            value: settings.batchScanMode,
            onChanged: (val) => settings.setBatchScanMode(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.autoFocusLabel,
            value: settings.useAutoFocus,
            onChanged: (val) => settings.setUseAutoFocus(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.touchFocusLabel,
            subtitle: AppStrings.touchFocusDesc,
            value: settings.touchFocus,
            onChanged: settings.useAutoFocus
                ? (val) => settings.setTouchFocus(val ?? false)
                : null,
          ),
          _SettingToggleTile(
            title: AppStrings.keepDuplicatesLabel,
            value: settings.keepDuplicates,
            onChanged: (val) => settings.setKeepDuplicates(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.customActionLabel,
            subtitle: AppStrings.customActionDesc,
            value: settings.customAction,
            onChanged: (val) => settings.setCustomAction(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.inAppBrowserLabel,
            value: settings.useInAppBrowser,
            onChanged: (val) => settings.setUseInAppBrowser(val ?? false),
          ),
          _SettingToggleTile(
            title: AppStrings.addHistoryLabel,
            value: settings.addScansToHistory,
            onChanged: (val) => settings.setAddScansToHistory(val ?? false),
          ),
          _SettingToggleTile(
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

class _ColorSchemeSelector extends StatelessWidget {
  final SettingsProvider settings;

  const _ColorSchemeSelector({required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            AppStrings.colorSchemeLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: SettingsProvider.colorSchemes.length,
          itemBuilder: (context, index) {
            final color = SettingsProvider.colorSchemes[index];
            final isSelected = settings.colorSchemeIndex == index;

            return InkWell(
              onTap: () => settings.setColorSchemeIndex(index),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? (theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87)
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SettingToggleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const _SettingToggleTile({
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onChanged != null;

    return CheckboxListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isEnabled ? null : theme.disabledColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled
                    ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65)
                    : theme.disabledColor.withValues(alpha: 0.5),
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: theme.primaryColor,
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 2.0,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingToggleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const SettingToggleTile({
    super.key,
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

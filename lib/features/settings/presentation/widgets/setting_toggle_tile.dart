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

    return Semantics(
      checked: value,
      enabled: isEnabled,
      child: InkWell(
        onTap: isEnabled ? () => onChanged!(!value) : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: subtitle == null ? 96 : 112),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 20,
                          color: isEnabled ? null : theme.disabledColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            height: 1.35,
                            color: isEnabled
                                ? theme.textTheme.bodyMedium?.color
                                : theme.disabledColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: value,
                    onChanged: onChanged,
                    activeColor: theme.primaryColor,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: isEnabled
                          ? theme.colorScheme.onSurface
                          : theme.disabledColor,
                      width: 2.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

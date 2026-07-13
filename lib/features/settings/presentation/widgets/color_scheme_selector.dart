import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import 'package:qr_code_scanner/core/providers/responsive_provider.dart';

class ColorSchemeSelector extends StatelessWidget {
  final SettingsProvider settings;

  const ColorSchemeSelector({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = context.watch<ResponsiveProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 28, 26, 26),
          child: Text(
            AppStrings.colorSchemeLabel,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(26, 0, 26, 28),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: responsive.isMobile ? 6 : (responsive.isTablet ? 12 : 18),
            crossAxisSpacing: 20,
            mainAxisSpacing: 18,
            childAspectRatio: 1,
          ),
          itemCount: AppColors.colorSchemes.length,
          itemBuilder: (context, index) {
            final color = AppColors.colorSchemes[index];
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
                            ? AppColors.white
                            : AppColors.black87)
                        : AppColors.transparent,
                    width: 2.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: AppColors.white, size: 20)
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';

class EmptyFavoritesView extends StatelessWidget {
  const EmptyFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.3) ?? Colors.grey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noFavoritesYet,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.titleLarge?.color?.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tapHeartIconToFavorite,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.4),
                ),
          ),
        ],
      ),
    );
  }
}

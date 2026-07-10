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
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noFavoritesYet,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tapHeartIconToFavorite,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}

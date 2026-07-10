import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/favorite_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import 'package:qr_code_scanner/features/history/presentation/widgets/history_item_card.dart';
import '../widgets/empty_favorites_view.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  void _showClearFavoritesConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.redAccent, size: 24),
            SizedBox(width: 10),
            Text(AppStrings.clearFevoriteTitle),
          ],
        ),
        content: const Text(AppStrings.clearFevoriteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              AppStrings.cancelText,
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<FavoriteProvider>().clearFavorites();
              Navigator.of(ctx).pop();
            },
            child: const Text(AppStrings.clearText, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favoriteString),
        centerTitle: true,
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, provider, child) {
              if (provider.favorites.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                ),
                tooltip: AppStrings.clearAllFavoritesTooltip,
                onPressed: () => _showClearFavoritesConfirmation(context),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final items = favoriteProvider.favorites;

          if (items.isEmpty) {
            return const EmptyFavoritesView();
          }

          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final item = items[index];
              return HistoryItemCard(
                item: item,
                onDelete: () {
                  favoriteProvider.removeFavorite(item.data);
                },
              );
            },
          );
        },
      ),
    );
  }
}

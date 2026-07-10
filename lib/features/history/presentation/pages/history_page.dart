import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/empty_history_view.dart';
import '../widgets/history_item_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.redAccent, size: 24),
            SizedBox(width: 10),
            Text(AppStrings.clearHistoryTitle),
          ],
        ),
        content: const Text(AppStrings.clearHistoryMessage),
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
              context.read<HistoryProvider>().clearHistory();
              Navigator.of(ctx).pop();
            },
            child: const Text(
              AppStrings.clearText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.historyString),
        centerTitle: true,
        actions: [
          Consumer<HistoryProvider>(
            builder: (context, provider, child) {
              if (provider.items.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                ),
                tooltip: AppStrings.clearText,
                onPressed: () => _showClearConfirmation(context),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          final items = historyProvider.items;

          if (items.isEmpty) {
            return const EmptyHistoryView();
          }

          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final item = items[index];
              return HistoryItemCard(
                item: item,
                onDelete: () {
                  historyProvider.removeHistoryItem(index);
                },
              );
            },
          );
        },
      ),
    );
  }
}

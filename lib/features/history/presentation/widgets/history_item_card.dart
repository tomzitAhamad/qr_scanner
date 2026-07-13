import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/models/history_item.dart';
import '../../../../core/providers/favorite_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../scanner/services/qr_launcher_service.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onDelete;

  const HistoryItemCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return "$day/$month/$year $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final isCamera = item.scanType.toLowerCase() == 'camera';
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFav = favoriteProvider.isFavorite(item.data);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          QrLauncherService.launchQr(context: context, qrData: item.data);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isCamera
                          ? AppColors.cameraScanBg.withValues(alpha: 0.15)
                          : AppColors.imageScanBg.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCamera
                            ? AppColors.cameraScanBg.withValues(alpha: 0.5)
                            : AppColors.imageScanBg.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCamera ? Icons.camera_alt : Icons.image,
                          size: 14,
                          color: isCamera
                              ? AppColors.cameraIcon
                              : AppColors.imageIcon,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isCamera ? "Camera Scan" : "Image Scan",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCamera
                                ? AppColors.cameraText
                                : AppColors.imageText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                item.data,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              Container(height: 1, color: Theme.of(context).dividerColor),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDateTime(item.scanTime),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
                          size: 18,
                        ),
                        onPressed: () {
                          favoriteProvider.toggleFavorite(item);
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.open_in_new,
                          color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
                          size: 18,
                        ),
                        onPressed: () {
                          QrLauncherService.launchQr(
                            context: context,
                            qrData: item.data,
                          );
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

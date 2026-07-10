import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/history_item.dart';
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
      ),
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
                          ? const Color(0xFF2563EB).withOpacity(0.15)
                          : Colors.purple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCamera
                            ? const Color(0xFF2563EB).withOpacity(0.5)
                            : Colors.purple.withOpacity(0.5),
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
                              ? const Color(0xFF3B82F6)
                              : Colors.purpleAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isCamera ? "Camera Scan" : "Image Scan",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCamera
                                ? const Color(0xFF60A5FA)
                                : Colors.purple[200],
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              Container(height: 1, color: Colors.white.withOpacity(0.05)),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDateTime(item.scanTime),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.open_in_new,
                          color: Colors.white.withOpacity(0.6),
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

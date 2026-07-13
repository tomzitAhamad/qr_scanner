import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/create_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/responsive_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/create_qr_option_widgets.dart';

class CreateQrPage extends StatelessWidget {
  const CreateQrPage({super.key});

  Future<void> _onOptionTap(BuildContext context, Map<String, dynamic> option) async {
    final type = option['type'] as String;
    final title = option['title'] as String;

    if (type == "clipboard") {
      final provider = context.read<CreateQrProvider>();
      final success = await provider.generateFromClipboard();
      if (success) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            "/create_qr/form",
            arguments: {
              "type": "clipboard_success",
              "title": "Clipboard Contents",
            },
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Clipboard is empty or doesn't contain text!"),
            ),
          );
        }
      }
    } else {
      Navigator.pushNamed(
        context,
        "/create_qr/form",
        arguments: {
          "type": type,
          "title": title,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = context.watch<ResponsiveProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create"),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                "Create QR",
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (responsive.isMobile)
              CreateOptionList(
                options: createQrOptions,
                onTap: (option) => _onOptionTap(context, option),
              )
            else
              CreateOptionGrid(
                options: createQrOptions,
                onTap: (option) => _onOptionTap(context, option),
                crossAxisCount: responsive.isTablet ? 2 : 3,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

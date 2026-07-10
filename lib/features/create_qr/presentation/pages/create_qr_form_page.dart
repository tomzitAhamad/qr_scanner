import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/create_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/features/create_qr/presentation/widgets/create_qr_form_fields.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQrFormPage extends StatefulWidget {
  final String type;
  final String title;

  const CreateQrFormPage({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<CreateQrFormPage> createState() => _CreateQrFormPageState();
}

class _CreateQrFormPageState extends State<CreateQrFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _state = CreateQrFormControllers();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateQrProvider>().reset();
    });
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _onGenerate(CreateQrProvider provider) {
    if (widget.type != "clipboard_success" && !_formKey.currentState!.validate()) {
      return;
    }

    switch (widget.type) {
      case "url":
        provider.generateUrlQr(_state.urlController.text.trim());
        break;
      case "text":
        provider.generateTextQr(_state.textController.text.trim());
        break;
      case "phone":
        provider.generatePhoneQr(_state.phoneController.text.trim());
        break;
      case "email":
        provider.generateEmailQr(
          to: _state.emailController.text.trim(),
          subject: _state.subjectController.text.trim(),
          body: _state.bodyController.text.trim(),
        );
        break;
      case "sms":
        provider.generateSmsQr(
          phone: _state.phoneController.text.trim(),
          message: _state.messageController.text.trim(),
        );
        break;
      case "geo":
        provider.generateGeoQr(
          latitude: _state.latitudeController.text.trim(),
          longitude: _state.longitudeController.text.trim(),
        );
        break;
      case "wifi":
        provider.generateWifiQr(
          ssid: _state.ssidController.text.trim(),
          password: _state.passwordController.text.trim(),
          security: _state.wifiSecurity,
        );
        break;
      case "contact":
        provider.generateContactQr(
          name: _state.nameController.text.trim(),
          phone: _state.phoneController.text.trim(),
          email: _state.emailController.text.trim(),
          org: _state.orgController.text.trim(),
          address: _state.addressController.text.trim(),
          notes: _state.notesController.text.trim(),
        );
        break;
      case "calendar":
        provider.generateCalendarQr(
          title: _state.eventTitleController.text.trim(),
          location: _state.eventLocationController.text.trim(),
          description: _state.eventDescController.text.trim(),
          start: _state.eventStartController.text.trim(),
          end: _state.eventEndController.text.trim(),
        );
        break;
    }

    if (provider.generatedQrData.isNotEmpty) {
      context.read<HistoryProvider>().addHistoryItem(
            data: provider.generatedQrData,
            type: widget.title,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateQrProvider>();

    if (widget.type == "clipboard_success" && !provider.isQrGenerated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HistoryProvider>().addHistoryItem(
              data: provider.generatedQrData,
              type: "Clipboard",
            );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!provider.isQrGenerated) ...[
              Form(
                key: _formKey,
                child: CreateQrFormFields(
                  type: widget.type,
                  state: _state,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _onGenerate(provider),
                child: const Text(
                  "Generate QR Code",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else ...[
              Center(
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: QrImageView(
                      data: provider.generatedQrData,
                      version: QrVersions.auto,
                      size: 220.0,
                      foregroundColor: Colors.black,
                      gapless: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "QR Code Generated!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Raw Content",
                      style: TextStyle(fontSize: 11, color: Colors.white54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.generatedQrData,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: provider.generatedQrData));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(AppStrings.copiedToClipboard)),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy_outlined, size: 18),
                          SizedBox(width: 8),
                          Text("Copy Text"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                      ),
                      onPressed: () {
                        provider.reset();
                        if (widget.type == "clipboard_success") {
                          Navigator.pop(context);
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 18),
                          SizedBox(width: 8),
                          Text("Reset Form"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

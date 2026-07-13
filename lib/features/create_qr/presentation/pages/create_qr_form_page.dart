import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/create_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import 'package:qr_code_scanner/features/create_qr/presentation/widgets/create_qr_form_fields.dart';
import 'package:qr_code_scanner/features/create_qr/presentation/widgets/create_qr_form_controllers.dart';
import 'package:qr_code_scanner/features/create_qr/presentation/widgets/generated_qr_result.dart';

class CreateQrFormPage extends StatefulWidget {
  final String type;
  final String title;

  const CreateQrFormPage({super.key, required this.type, required this.title});

  @override
  State<CreateQrFormPage> createState() => _CreateQrFormPageState();
}

class _CreateQrFormPageState extends State<CreateQrFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = CreateQrFormControllers();
  bool _clipboardHistoryAdded = false;

  bool get _isClipboardResult => widget.type == 'clipboard_success';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final createQr = context.read<CreateQrProvider>();
      if (_isClipboardResult) {
        _addClipboardHistory(createQr);
      } else {
        createQr.reset();
      }
    });
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _addClipboardHistory(CreateQrProvider provider) {
    if (_clipboardHistoryAdded || provider.generatedQrData.isEmpty) return;

    _clipboardHistoryAdded = true;
    context.read<HistoryProvider>().addHistoryItem(
      data: provider.generatedQrData,
      type: 'Clipboard',
    );
  }

  void _generate(CreateQrProvider provider) {
    if (!_formKey.currentState!.validate()) return;

    _controllers.generate(provider, widget.type);

    if (provider.generatedQrData.isNotEmpty) {
      context.read<HistoryProvider>().addHistoryItem(
        data: provider.generatedQrData,
        type: widget.title,
      );
    }
  }

  void _reset(CreateQrProvider provider) {
    provider.reset();
    if (_isClipboardResult) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateQrProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: provider.isQrGenerated
            ? GeneratedQrResult(
                qrData: provider.generatedQrData,
                onReset: () => _reset(provider),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: _formKey,
                    child: CreateQrFormFields(
                      type: widget.type,
                      state: _controllers,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _generate(provider),
                    child: const Text(
                      'Generate QR Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

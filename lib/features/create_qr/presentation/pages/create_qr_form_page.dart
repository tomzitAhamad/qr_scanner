import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/create_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQrFormPage extends StatefulWidget {
  final String type;
  final String title;

  const CreateQrFormPage({super.key, required this.type, required this.title});

  @override
  State<CreateQrFormPage> createState() => _CreateQrFormPageState();
}

class _MyFormStateHelper {
  // Common Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final orgController = TextEditingController();
  final notesController = TextEditingController();

  final urlController = TextEditingController();
  final textController = TextEditingController();

  final subjectController = TextEditingController();
  final bodyController = TextEditingController();

  final messageController = TextEditingController();

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  String wifiSecurity = "WPA";

  final eventTitleController = TextEditingController();
  final eventLocationController = TextEditingController();
  final eventDescController = TextEditingController();
  final eventStartController = TextEditingController();
  final eventEndController = TextEditingController();

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    orgController.dispose();
    notesController.dispose();
    urlController.dispose();
    textController.dispose();
    subjectController.dispose();
    bodyController.dispose();
    messageController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    ssidController.dispose();
    passwordController.dispose();
    eventTitleController.dispose();
    eventLocationController.dispose();
    eventDescController.dispose();
    eventStartController.dispose();
    eventEndController.dispose();
  }
}

class _CreateQrFormPageState extends State<CreateQrFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _state = _MyFormStateHelper();

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
    if (widget.type != "clipboard_success" &&
        !_formKey.currentState!.validate()) {
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

  Widget _buildFormFields() {
    switch (widget.type) {
      case "url":
        return TextFormField(
          controller: _state.urlController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: "URL",
            hintText: "Enter website URL",
            prefixIcon: Icon(Icons.link),
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? "URL is required" : null,
        );
      case "text":
        return TextFormField(
          controller: _state.textController,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: "Text",
            hintText: "Enter raw text content",
            prefixIcon: Icon(Icons.text_fields_outlined),
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? "Text is required" : null,
        );
      case "phone":
        return TextFormField(
          controller: _state.phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: "Phone Number",
            hintText: "Enter contact number",
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? "Phone number is required"
              : null,
        );
      case "email":
        return Column(
          children: [
            TextFormField(
              controller: _state.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address",
                hintText: "Enter recipient email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Email is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.subjectController,
              decoration: const InputDecoration(
                labelText: "Subject",
                hintText: "Enter email subject",
                prefixIcon: Icon(Icons.subject),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.bodyController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Message Body",
                hintText: "Enter email body content",
                prefixIcon: Icon(Icons.message_outlined),
              ),
            ),
          ],
        );
      case "sms":
        return Column(
          children: [
            TextFormField(
              controller: _state.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Recipient Phone",
                hintText: "Enter mobile number",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Phone is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.messageController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "SMS Message",
                hintText: "Enter SMS text",
                prefixIcon: Icon(Icons.sms_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Message is required"
                  : null,
            ),
          ],
        );
      case "geo":
        return Column(
          children: [
            TextFormField(
              controller: _state.latitudeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: "Latitude",
                hintText: "e.g. 23.8103",
                prefixIcon: Icon(Icons.map_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Latitude is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.longitudeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: "Longitude",
                hintText: "e.g. 90.4125",
                prefixIcon: Icon(Icons.explore_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Longitude is required"
                  : null,
            ),
          ],
        );
      case "wifi":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _state.ssidController,
              decoration: const InputDecoration(
                labelText: "Network SSID",
                hintText: "Enter Wi-Fi network name",
                prefixIcon: Icon(Icons.wifi),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Network SSID is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter network password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Security Type",
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _state.wifiSecurity,
              dropdownColor: const Color(0xFF1E1E1E),
              items: ["WPA", "WEP", "nopass"].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type == "nopass" ? "Open (No Password)" : type),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _state.wifiSecurity = val;
                  });
                }
              },
            ),
          ],
        );
      case "contact":
        return Column(
          children: [
            TextFormField(
              controller: _state.nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                hintText: "Enter contact name",
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Name is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                hintText: "Enter phone number",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address",
                hintText: "Enter email address",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.orgController,
              decoration: const InputDecoration(
                labelText: "Organization / Company",
                hintText: "Enter company name",
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Address",
                hintText: "Enter physical address",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Notes",
                hintText: "Enter extra description or info",
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
            ),
          ],
        );
      case "calendar":
        return Column(
          children: [
            TextFormField(
              controller: _state.eventTitleController,
              decoration: const InputDecoration(
                labelText: "Event Title",
                hintText: "Enter meeting or event name",
                prefixIcon: Icon(Icons.event),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Event title is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.eventLocationController,
              decoration: const InputDecoration(
                labelText: "Event Location",
                hintText: "Enter venue or location",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.eventDescController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Enter event description",
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.eventStartController,
              decoration: const InputDecoration(
                labelText: "Start Date (YYYYMMDD)",
                hintText: "e.g. 20260710",
                prefixIcon: Icon(Icons.date_range_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "Start Date is required"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _state.eventEndController,
              decoration: const InputDecoration(
                labelText: "End Date (YYYYMMDD)",
                hintText: "e.g. 20260711",
                prefixIcon: Icon(Icons.date_range),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? "End Date is required"
                  : null,
            ),
          ],
        );
      case "clipboard_success":
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateQrProvider>();

    // If clipboard success was passed, trigger generation once
    if (widget.type == "clipboard_success" && !provider.isQrGenerated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Trigger save to history as well
        context.read<HistoryProvider>().addHistoryItem(
          data: provider.generatedQrData,
          type: "Clipboard",
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!provider.isQrGenerated) ...[
              Form(key: _formKey, child: _buildFormFields()),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _onGenerate(provider),
                child: const Text(
                  "Generate QR Code",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              // QR Generated Result View
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
                        Clipboard.setData(
                          ClipboardData(text: provider.generatedQrData),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.copiedToClipboard),
                          ),
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

import 'package:flutter/material.dart';

class CreateQrFormControllers {
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

class CreateQrFormFields extends StatefulWidget {
  final String type;
  final CreateQrFormControllers state;

  const CreateQrFormFields({
    super.key,
    required this.type,
    required this.state,
  });

  @override
  State<CreateQrFormFields> createState() => _CreateQrFormFieldsState();
}

class _CreateQrFormFieldsState extends State<CreateQrFormFields> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case "url":
        return TextFormField(
          controller: widget.state.urlController,
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
          controller: widget.state.textController,
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
          controller: widget.state.phoneController,
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
              controller: widget.state.emailController,
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
              controller: widget.state.subjectController,
              decoration: const InputDecoration(
                labelText: "Subject",
                hintText: "Enter email subject",
                prefixIcon: Icon(Icons.subject),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.bodyController,
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
              controller: widget.state.phoneController,
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
              controller: widget.state.messageController,
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
              controller: widget.state.latitudeController,
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
              controller: widget.state.longitudeController,
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
              controller: widget.state.ssidController,
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
              controller: widget.state.passwordController,
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
              initialValue: widget.state.wifiSecurity,
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
                    widget.state.wifiSecurity = val;
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
              controller: widget.state.nameController,
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
              controller: widget.state.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                hintText: "Enter phone number",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address",
                hintText: "Enter email address",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.orgController,
              decoration: const InputDecoration(
                labelText: "Organization / Company",
                hintText: "Enter company name",
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Address",
                hintText: "Enter physical address",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.notesController,
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
              controller: widget.state.eventTitleController,
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
              controller: widget.state.eventLocationController,
              decoration: const InputDecoration(
                labelText: "Event Location",
                hintText: "Enter venue or location",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.eventDescController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Enter event description",
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.state.eventStartController,
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
              controller: widget.state.eventEndController,
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
      default:
        return const SizedBox();
    }
  }
}

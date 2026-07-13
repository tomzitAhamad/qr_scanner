import 'package:flutter/material.dart';
import '../../../../core/providers/create_qr_provider.dart';

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

  void generate(CreateQrProvider provider, String type) {
    switch (type) {
      case 'url':
        provider.generateUrlQr(urlController.text.trim());
      case 'text':
        provider.generateTextQr(textController.text.trim());
      case 'phone':
        provider.generatePhoneQr(phoneController.text.trim());
      case 'email':
        provider.generateEmailQr(
          to: emailController.text.trim(),
          subject: subjectController.text.trim(),
          body: bodyController.text.trim(),
        );
      case 'sms':
        provider.generateSmsQr(
          phone: phoneController.text.trim(),
          message: messageController.text.trim(),
        );
      case 'geo':
        provider.generateGeoQr(
          latitude: latitudeController.text.trim(),
          longitude: longitudeController.text.trim(),
        );
      case 'wifi':
        provider.generateWifiQr(
          ssid: ssidController.text.trim(),
          password: passwordController.text.trim(),
          security: wifiSecurity,
        );
      case 'contact':
        provider.generateContactQr(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          org: orgController.text.trim(),
          address: addressController.text.trim(),
          notes: notesController.text.trim(),
        );
      case 'calendar':
        provider.generateCalendarQr(
          title: eventTitleController.text.trim(),
          location: eventLocationController.text.trim(),
          description: eventDescController.text.trim(),
          start: eventStartController.text.trim(),
          end: eventEndController.text.trim(),
        );
    }
  }
}

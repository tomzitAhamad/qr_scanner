import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class MyQrProvider extends ChangeNotifier {
  String _fullName = "";
  String _organization = "";
  String _address = "";
  String _phoneNumber = "";
  String _email = "";
  String _notes = "";
  String? _generatedQrCodeData;

  String get fullName => _fullName;
  String get organization => _organization;
  String get address => _address;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get notes => _notes;
  String? get generatedQrCodeData => _generatedQrCodeData;
  bool get hasQrCode =>
      _generatedQrCodeData != null && _generatedQrCodeData!.isNotEmpty;

  void updateFields({
    required String name,
    required String org,
    required String addr,
    required String phone,
    required String mail,
    required String note,
  }) {
    _fullName = name;
    _organization = org;
    _address = addr;
    _phoneNumber = phone;
    _email = mail;
    _notes = note;
    notifyListeners();
  }

  void generateQrCode() {
    if (_fullName.trim().isEmpty && _phoneNumber.trim().isEmpty) {
      _generatedQrCodeData = null;
      notifyListeners();
      return;
    }

    final vcard = StringBuffer()
      ..writeln("BEGIN:VCARD")
      ..writeln("VERSION:3.0")
      ..writeln("FN:$_fullName")
      ..writeln("ORG:$_organization")
      ..writeln("ADR:;;$_address;;;;")
      ..writeln("TEL:$_phoneNumber")
      ..writeln("EMAIL:$_email")
      ..writeln("NOTE:$_notes")
      ..writeln("END:VCARD");

    _generatedQrCodeData = vcard.toString();
    notifyListeners();
  }

  void clearQrCode() {
    _fullName = "";
    _organization = "";
    _address = "";
    _phoneNumber = "";
    _email = "";
    _notes = "";
    _generatedQrCodeData = null;
    notifyListeners();
  }

  void editQrCode() {
    _generatedQrCodeData = null;
    notifyListeners();
  }

  void importFromContact(Contact contact) {
    _fullName = contact.displayName ?? "";
    _phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : "";
    _email = contact.emails.isNotEmpty ? contact.emails.first.address : "";
    _address = contact.addresses.isNotEmpty ? (contact.addresses.first.formatted ?? "") : "";
    _organization = contact.organizations.isNotEmpty ? (contact.organizations.first.name ?? "") : "";
    _notes = contact.notes.isNotEmpty ? contact.notes.first.note : "";
    generateQrCode();
  }

  Future<bool> pickContactFromDevice(BuildContext context) async {
    try {
      final status = await Permission.contacts.request();

      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Contacts permission is required to select contacts.",
              ),
            ),
          );
        }
        return false;
      }

      final Contact? contact = await FlutterContacts.native.showPicker();
      if (contact == null) return false;

      final fullContact = await FlutterContacts.get(
        contact.id!,
        properties: {
          ContactProperty.phone,
          ContactProperty.email,
          ContactProperty.address,
          ContactProperty.organization,
        },
      );
      if (fullContact == null) return false;

      _fullName = fullContact.displayName ?? "";

      if (fullContact.phones.isNotEmpty) {
        _phoneNumber = fullContact.phones.first.number;
      } else {
        _phoneNumber = "";
      }

      if (fullContact.emails.isNotEmpty) {
        _email = fullContact.emails.first.address;
      } else {
        _email = "";
      }

      if (fullContact.addresses.isNotEmpty) {
        _address = fullContact.addresses.first.formatted ?? "";
      } else {
        _address = "";
      }

      if (fullContact.organizations.isNotEmpty) {
        _organization = fullContact.organizations.first.name ?? "";
      } else {
        _organization = "";
      }

      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error picking contact: $e")));
      }
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import '../../../../core/providers/my_qr_provider.dart';

class MyQrForm extends StatefulWidget {
  const MyQrForm({super.key});

  @override
  State<MyQrForm> createState() => _MyQrFormState();
}

class _MyQrFormState extends State<MyQrForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _orgController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<MyQrProvider>();
    _nameController = TextEditingController(text: provider.fullName);
    _orgController = TextEditingController(text: provider.organization);
    _addressController = TextEditingController(text: provider.address);
    _phoneController = TextEditingController(text: provider.phoneNumber);
    _emailController = TextEditingController(text: provider.email);
    _notesController = TextEditingController(text: provider.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateControllersFromProvider() {
    final provider = context.read<MyQrProvider>();
    _nameController.text = provider.fullName;
    _orgController.text = provider.organization;
    _addressController.text = provider.address;
    _phoneController.text = provider.phoneNumber;
    _emailController.text = provider.email;
    _notesController.text = provider.notes;
  }

  @override
  Widget build(BuildContext context) {
    final myQrProvider = context.read<MyQrProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.createYourContactQrCode,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.fillDetailsOrPickContact,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            _buildTextField(
              controller: _nameController,
              label: AppStrings.fullNameLabel,
              icon: Icons.person_outline,
              hint: AppStrings.fullNameHint,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: AppStrings.phoneNumberLabel,
              icon: Icons.phone_outlined,
              hint: AppStrings.phoneNumberHint,
              keyboardType: TextInputType.phone,
              suffix: IconButton(
                icon: const Icon(Icons.contact_phone, color: Color(0xFF2563EB)),
                tooltip: AppStrings.pickFromContactsTooltip,
                onPressed: () async {
                  final picked = await myQrProvider.pickContactFromDevice(
                    context,
                  );
                  if (picked) {
                    setState(() {
                      _updateControllersFromProvider();
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _orgController,
              label: AppStrings.orgLabel,
              icon: Icons.business_outlined,
              hint: AppStrings.orgHint,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _emailController,
              label: AppStrings.emailLabel,
              icon: Icons.email_outlined,
              hint: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _addressController,
              label: AppStrings.addressLabel,
              icon: Icons.location_on_outlined,
              hint: AppStrings.addressHint,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _notesController,
              label: AppStrings.notesLabel,
              icon: Icons.note_alt_outlined,
              hint: AppStrings.notesHint,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                myQrProvider.updateFields(
                  name: _nameController.text,
                  org: _orgController.text,
                  addr: _addressController.text,
                  phone: _phoneController.text,
                  mail: _emailController.text,
                  note: _notesController.text,
                );
                myQrProvider.generateQrCode();
              },
              child: const Text(
                AppStrings.generateQrCodeButton,
                style: TextStyle(
                  color: Colors.white,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import 'package:qr_code_scanner/core/providers/my_qr_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/my_qr_form.dart';
import '../widgets/my_qr_display_view.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myQrProvider = context.watch<MyQrProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myQrString),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: myQrProvider.hasQrCode
          ? const MyQrDisplayView()
          : const MyQrForm(),
    );
  }
}


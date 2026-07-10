import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_strings.dart';
import '../../../../core/widgets/app_drawer.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myQrString),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: const Center(child: Text("My QR Page")),
    );
  }
}

import 'package:flutter/material.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My QR")),
      body: const Center(child: Text("My QR Page")),
    );
  }
}

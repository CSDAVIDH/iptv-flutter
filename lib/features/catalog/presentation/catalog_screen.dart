import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Catálogo'),
      body: Center(child: Text('Pantalla de Catálogo')),
    );
  }
}

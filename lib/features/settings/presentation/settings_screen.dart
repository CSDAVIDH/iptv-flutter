import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Configuración'),
      body: Center(child: Text('Bienvenido a Player')),
    );
  }
}

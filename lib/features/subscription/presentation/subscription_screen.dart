import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Suscripción'),
      body: Center(child: Text('Pantalla de Suscripción')),
    );
  }
}

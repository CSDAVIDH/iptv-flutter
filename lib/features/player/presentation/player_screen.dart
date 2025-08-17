import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'IPTV Player'),
      body: Center(child: Text('Bienvenido a Player')),
    );
  }
}

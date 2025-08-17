import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'core/constants/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPTV App',
      theme: ThemeData(primaryColor: AppColors.primary, useMaterial3: true),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

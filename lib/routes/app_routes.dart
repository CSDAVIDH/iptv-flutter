import 'package:flutter/material.dart';

// Importa aquí tus pantallas
import '../features/home/presentation/home_screen.dart';
import '../features/login/presentation/login_screen.dart';
import '../features/catalog/presentation/catalog_screen.dart';
import '../features/player/presentation/player_screen.dart';
import '../features/subscription/presentation/subscription_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String catalog = '/catalog';
  static const String player = '/player';
  static const String subscription = '/subscription';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    catalog: (context) => const CatalogScreen(
          m3uUrl: '',
        ),
    player: (context) => const PlayerScreen(),
    subscription: (context) => const SubscriptionScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites_channels';

  static Future<List<Channel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    
    return favoritesJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Channel(
        name: map['name'],
        url: map['url'],
        logo: map['logo'],
        group: map['group'],
        tvgId: map['tvgId'],
        tvgName: map['tvgName'],
        isFavorite: true,
      );
    }).toList();
  }

  static Future<bool> isFavorite(Channel channel) async {
    final favorites = await getFavorites();
    return favorites.any((fav) => fav.url == channel.url);
  }

  static Future<void> addToFavorites(Channel channel) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    if (!favorites.any((fav) => fav.url == channel.url)) {
      favorites.add(channel.copyWith(isFavorite: true));
      
      final favoritesJson = favorites.map((channel) => jsonEncode({
        'name': channel.name,
        'url': channel.url,
        'logo': channel.logo,
        'group': channel.group,
        'tvgId': channel.tvgId,
        'tvgName': channel.tvgName,
      })).toList();
      
      await prefs.setStringList(_favoritesKey, favoritesJson);
    }
  }

  static Future<void> removeFromFavorites(Channel channel) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((fav) => fav.url == channel.url);
    
    final favoritesJson = favorites.map((channel) => jsonEncode({
      'name': channel.name,
      'url': channel.url,
      'logo': channel.logo,
      'group': channel.group,
      'tvgId': channel.tvgId,
      'tvgName': channel.tvgName,
    })).toList();
    
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  static Future<void> toggleFavorite(Channel channel) async {
    final isFav = await isFavorite(channel);
    
    if (isFav) {
      await removeFromFavorites(channel);
    } else {
      await addToFavorites(channel);
    }
  }
}
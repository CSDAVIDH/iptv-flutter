import 'dart:convert';
import 'package:http/http.dart' as http;
import '/../../core/models/channel.dart';

class M3uService {
  Future<List<Channel>> fetchChannels(String m3uUrl) async {
    return loadChannelsFromM3U(m3uUrl);
  }

  Future<List<Channel>> loadChannelsFromM3U(String m3uUrl) async {
    final response = await http.get(Uri.parse(m3uUrl));
    if (response.statusCode == 200) {
      final lines = const LineSplitter().convert(response.body);
      List<Channel> channels = [];
      String? currentName;
      String? currentLogo;
      String? currentGroup;
      String? currentTvgId;
      String? currentTvgName;

      for (var line in lines) {
        if (line.startsWith('#EXTINF')) {
          // Extrae el nombre
          currentName = line.split(',').last.trim();

          // Extrae el logo si existe
          final logoMatch = RegExp(r'tvg-logo="([^"]+)"').firstMatch(line);
          currentLogo = logoMatch?.group(1);

          // Extrae el grupo
          final groupMatch = RegExp(r'group-title="([^"]+)"').firstMatch(line);
          currentGroup = groupMatch?.group(1);

          // Extrae tvg-id
          final tvgIdMatch = RegExp(r'tvg-id="([^"]+)"').firstMatch(line);
          currentTvgId = tvgIdMatch?.group(1);

          // Extrae tvg-name
          final tvgNameMatch = RegExp(r'tvg-name="([^"]+)"').firstMatch(line);
          currentTvgName = tvgNameMatch?.group(1);

        } else if (line.startsWith('http')) {
          channels.add(
            Channel(
              name: currentName ?? 'Canal',
              url: line.trim(),
              logo: currentLogo,
              group: currentGroup,
              tvgId: currentTvgId,
              tvgName: currentTvgName,
            ),
          );
          // Resetear variables para el siguiente canal
          currentName = null;
          currentLogo = null;
          currentGroup = null;
          currentTvgId = null;
          currentTvgName = null;
        } else if (line.startsWith('#EXTLOGO')) {
          // Soporte para líneas con EXTLOGO
          currentLogo = line.split(',').last.trim();
        }
      }
      return channels;
    }
    return [];
  }
}

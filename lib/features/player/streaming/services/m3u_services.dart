import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/channel.dart';

class M3uService {
  Future<List<Channel>> loadChannelsFromM3U(String m3uUrl) async {
    try {
      final response = await http.get(Uri.parse(m3uUrl));
      if (response.statusCode == 200) {
        final lines = const LineSplitter().convert(response.body);
        List<Channel> channels = [];
        String? currentName;
        String? currentLogo;

        for (var line in lines) {
          line = line.trim();
          if (line.startsWith('#EXTINF')) {
            // Extrae el nombre del canal
            final parts = line.split(',');
            if (parts.length > 1) {
              currentName = parts.last.trim();
            }

            // Extrae el logo si existe
            final logoMatch = RegExp(r'tvg-logo=["\']([^"\']+)["\']').firstMatch(line);
            currentLogo = logoMatch?.group(1);
          } else if (line.startsWith('#EXTLOGO')) {
            // Soporte para líneas con EXTLOGO
            final parts = line.split(',');
            if (parts.length > 1) {
              currentLogo = parts.last.trim();
            }
          } else if (line.isNotEmpty && (line.startsWith('http') || line.startsWith('rtmp') || line.startsWith('rtsp'))) {
            // Agregar canal con URL válida
            channels.add(
              Channel(
                name: currentName ?? 'Canal sin nombre',
                url: line,
                logo: currentLogo,
              ),
            );
            // Reset para el próximo canal
            currentName = null;
            currentLogo = null;
          }
        }
        return channels;
      } else {
        throw Exception('Error al cargar la playlist M3U: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al procesar la playlist M3U: $e');
    }
  }
}

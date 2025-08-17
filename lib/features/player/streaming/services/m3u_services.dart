import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/models/channel.dart';

class M3uService {
  Future<List<Channel>> loadChannelsFromM3U(String m3uUrl) async {
    final response = await http.get(Uri.parse(m3uUrl));
    if (response.statusCode != 200) {
      throw Exception('No se pudo cargar el archivo M3U');
    }

    final lines = const LineSplitter().convert(response.body);
    List<Channel> channels = [];
    String? currentName;
    String? currentLogo;

    final protocols = ['http', 'https', 'rtmp', 'udp', 'rtsp', 'file'];

    for (var line in lines) {
      if (line.startsWith('#EXTINF')) {
        currentName = line.split(',').last.trim();
        final logoMatch = RegExp(r'tvg-logo="([^"]+)"').firstMatch(line);
        currentLogo = logoMatch?.group(1);
      } else if (protocols.any((p) => line.startsWith(p))) {
        channels.add(
          Channel(
            name: currentName ?? 'Canal',
            url: line.trim(),
            logo: currentLogo,
          ),
        );
      } else if (line.startsWith('#EXTLOGO')) {
        currentLogo = line.split(',').last.trim();
      }
    }
    return channels;
  }
}

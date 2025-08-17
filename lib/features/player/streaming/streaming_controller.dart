import 'services/m3u_services.dart';
import '../../../core/models/channel.dart';

class StreamingController {
  final M3uService _service = M3uService();

  Future<List<Channel>> getChannels(String m3uUrl) {
    return _service.loadChannelsFromM3U(m3uUrl);
  }
}

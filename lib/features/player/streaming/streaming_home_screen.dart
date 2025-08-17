import 'package:flutter/material.dart';
import '../../../core/models/channel.dart';
import 'streaming_controller.dart';
import 'streaming_screen.dart';

class StreamingHomeScreen extends StatefulWidget {
  final String m3uUrl;
  const StreamingHomeScreen({super.key, required this.m3uUrl});

  @override
  State<StreamingHomeScreen> createState() => _StreamingHomeScreenState();
}

class _StreamingHomeScreenState extends State<StreamingHomeScreen> {
  late Future<List<Channel>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _channelsFuture = StreamingController().getChannels(widget.m3uUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canales IPTV')),
      body: FutureBuilder<List<Channel>>(
        future: _channelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron canales'));
          }
          final channels = snapshot.data!;
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                leading: channel.logo != null && channel.logo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          channel.logo!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/placeholder.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover),
                        ),
                      )
                    : Image.asset('assets/images/placeholder.png',
                        width: 48, height: 48, fit: BoxFit.cover),
                title: Text(
                  channel.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  channel.url,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.more_vert),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StreamingScreen(
                        url: channel.url,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

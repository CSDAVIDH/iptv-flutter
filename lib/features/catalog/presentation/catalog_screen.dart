import 'package:flutter/material.dart';
import '../../player/streaming/services/m3u_services.dart';
import '../../../core/models/channel.dart';

class CatalogScreen extends StatelessWidget {
  final String m3uUrl;
  const CatalogScreen({super.key, required this.m3uUrl});

  @override
  Widget build(BuildContext context) {
    final m3uService = M3uService();
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: FutureBuilder<List<Channel>>(
        future: m3uService.loadChannelsFromM3U(m3uUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar canales'));
          }
          final channels = snapshot.data ?? [];
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                title: Text(channel.name),
                subtitle: Text(channel.url),
                leading: channel.logo != null
                    ? Image.network(
                        channel.logo!,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/placeholder.png',
                              width: 40, height: 40);
                        },
                      )
                    : Image.asset('assets/images/placeholder.png',
                        width: 40, height: 40),
              );
            },
          );
        },
      ),
    );
  }
}

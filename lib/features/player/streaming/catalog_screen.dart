import 'package:flutter/material.dart';
import 'services/m3u_services.dart'; // Import corregido
import '../../../core/models/channel.dart';

class CatalogScreen extends StatelessWidget {
  final String m3uUrl;
  const CatalogScreen({super.key, required this.m3uUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: FutureBuilder<List<Channel>>(
        future: loadChannelsFromM3U(m3uUrl),
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
                // ...otros widgets...
              );
            },
          );
        },
      ),
    );
  }
}

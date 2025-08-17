import 'package:flutter/material.dart';
import 'services/m3u_services.dart';
import '../../../core/models/channel.dart';

class CatalogScreen extends StatelessWidget {
  final String m3uUrl;
  const CatalogScreen({super.key, required this.m3uUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: FutureBuilder<List<Channel>>(
        future: M3uService().loadChannelsFromM3U(m3uUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Error al cargar canales'),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          final channels = snapshot.data ?? [];
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                title: Text(channel.name),
                subtitle: Text(channel.url),
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
              );
            },
          );
        },
      ),
    );
  }
}

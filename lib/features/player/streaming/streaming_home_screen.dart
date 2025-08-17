import 'package:flutter/material.dart';
import '../../../core/models/channel.dart';
import 'streaming_controller.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class StreamingHomeScreen extends StatefulWidget {
  final String m3uUrl;
  const StreamingHomeScreen({super.key, required this.m3uUrl});

  @override
  State<StreamingHomeScreen> createState() => _StreamingHomeScreenState();
}

class _StreamingHomeScreenState extends State<StreamingHomeScreen> {
  late Future<List<Channel>> _channelsFuture;
  Channel? _selectedChannel;
  bool _isError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _channelsFuture = StreamingController().getChannels(widget.m3uUrl);
  }

  Future<void> _initPlayer(String url) async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    final uri = Uri.tryParse(url);
    final isSupported = uri != null &&
        uri.scheme.isNotEmpty &&
        ['http', 'https'].contains(uri.scheme);

    if (url.isEmpty || !isSupported) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      _showErrorSnackbar('Canal no disponible o formato no soportado');
      return;
    }

    try {
      final response =
          await HttpClient().headUrl(uri).then((req) => req.close());
      if (response.statusCode >= 400) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
        _showErrorSnackbar('Canal no disponible');
        return;
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      _showErrorSnackbar('Canal no disponible');
      return;
    }

    setState(() {
      _isLoading = false;
      _isError = false;
    });
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget buildPlayer(Channel? channel) {
    if (channel == null || _isError) {
      return Center(
        child: Text(
          _isError
              ? 'Canal no disponible o error de reproducción'
              : 'Selecciona un canal',
          style: TextStyle(
            color: _isError ? Colors.redAccent : Colors.white70,
          ),
        ),
      );
    }
    return VideoPlayerWidget(url: channel.url);
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
          return Column(
            children: [
              Container(
                color: Colors.black,
                height: 220,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildPlayer(_selectedChannel),
              ),
              const Divider(height: 1, color: Colors.white24),
              Expanded(
                child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Card(
                        color: Colors.grey[900],
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _selectedChannel = channel;
                              _isError = false;
                            });
                            await _initPlayer(channel.url);
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: channel.logo != null &&
                                        channel.logo!.isNotEmpty
                                    ? Image.network(
                                        channel.logo!,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Image.asset(
                                                'assets/images/placeholder.png',
                                                width: 56,
                                                height: 56,
                                                fit: BoxFit.cover),
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.png',
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      channel.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      channel.url,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.play_arrow, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((_) {
        setState(() {
          _hasError = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Text(
          'Error al reproducir el canal',
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

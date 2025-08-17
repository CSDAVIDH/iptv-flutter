import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class StreamingScreen extends StatefulWidget {
  final String url;
  const StreamingScreen({super.key, required this.url});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  late VlcPlayerController _vlcController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    _vlcController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    _vlcController.addListener(() {
      final isPlaying = _vlcController.value.isPlaying;
      final hasError = _vlcController.value.hasError;

      if (hasError) {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      } else if (isPlaying) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    try {
      if (_vlcController.value.isInitialized) {
        _vlcController.stop();
        _vlcController.dispose();
      }
    } catch (_) {
      // Ignorar si no está inicializado
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproducción'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _isError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'canal no disponible',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _vlcController.value.errorDescription,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : VlcPlayer(
                    controller: _vlcController,
                    aspectRatio: 16 / 9,
                    placeholder: Image.network(
                      'https://awtv.com.br/wp-content/uploads/2024/10/LOGO-AWTV-1080X1080-300x300.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

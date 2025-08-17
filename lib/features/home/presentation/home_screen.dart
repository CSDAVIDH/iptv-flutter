import 'package:flutter/material.dart';
import 'package:iptv/features/player/streaming/streaming_home_screen.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/constants.dart'; // playlistUrl

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('IPTV Home'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Slider superior
          SizedBox(
            height: 200,
            child: PageView(
              children: [
                _sliderItem('https://www.menzig.es/images/a/2000/2646-h1.jpg'),
                _sliderItem(
                    'https://i0.wp.com/imgs.hipertextual.com/wp-content/uploads/2018/12/infinity-war.jpg?fit=780%2C439&quality=70&strip=all&ssl=1'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Fila horizontal de miniaturas VOD
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _vodItem('Beartown',
                    'https://via.placeholder.com/100x120.png?text=Beartown'),
                _vodItem('The Gift',
                    'https://via.placeholder.com/100x120.png?text=The+Gift'),
                _vodItem('Friends',
                    'https://via.placeholder.com/100x120.png?text=Friends'),
                _vodItem(
                    'F9', 'https://via.placeholder.com/100x120.png?text=F9'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Menú inferior de categorías
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _categoryItem(context, 'EN VIVO', Colors.red),
                _categoryItem(context, 'VOD', Colors.green),
                _categoryItem(context, 'ESPECIAL', Colors.blue),
                _categoryItem(context, 'CANALES 24/7', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderItem(String imageUrl) {
    return Image.network(imageUrl, fit: BoxFit.cover);
  }

  Widget _vodItem(String title, String imageUrl) {
    // Si la URL contiene 'via.placeholder.com', usa una imagen local
    final isPlaceholder = imageUrl.contains('via.placeholder.com');
    const localImage =
        'assets/images/placeholder.png'; // Pon aquí tu imagen local

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 90,
      child: Column(
        children: [
          Expanded(
            child: isPlaceholder
                ? Image.asset(localImage, fit: BoxFit.cover)
                : Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(BuildContext context, String title, Color color) {
    return InkWell(
      onTap: () {
        if (title == "EN VIVO") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const StreamingHomeScreen(
                m3uUrl: playlistUrl,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sección $title aún no implementada")),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

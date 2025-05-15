import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobMapPage extends StatelessWidget {
  final String location;

  const JobMapPage({super.key, required this.location});

  Future<void> _openMapWithIntent(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Harita açılamıyor: $address';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İş Konumu"),
        backgroundColor: Colors.blue, // AppBar arka plan rengi
        titleTextStyle: const TextStyle(
          color: Colors.white, // AppBar başlık rengi
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Geri butonu rengi
      ),
      body: Container( // Ana Container widget'ı
        decoration: const BoxDecoration(
          gradient: LinearGradient( // Arka plan gradyanı
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Açık mavi
              Color(0xFFFFFFFF), // Beyaz
            ],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center( // Center widget'ı ile içeriği ortala
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map, size: 100, color: Colors.blueAccent), // Harita ikonu
              const SizedBox(height: 30),
              Text(
                "İş yeri konumu:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[800]), // Başlık stili
              ),
              const SizedBox(height: 12),
              Text(
                location,
                style: const TextStyle(fontSize: 18, color: Colors.black87), // Konum stili
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _openMapWithIntent(location),
                icon: const Icon(Icons.navigation, color: Colors.white), // Navigasyon ikonu
                label: const Text("Google Haritalarda Aç", style: TextStyle(fontSize: 18, color: Colors.white)), // Buton metni stili
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: Colors.blue, // Buton rengi
                  shape: RoundedRectangleBorder( // Buton şekli
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5, // Buton gölgesi
                  shadowColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


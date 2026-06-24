import 'package:flutter/material.dart';
import '../../../../core/config/env_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Jika PROD wajib Biru Gelap, jika DEV menggunakan warna bebas (misal grey)
    final primaryColor = EnvConfig.isProduction ? const Color(0xFF0D1B2A) : Colors.blueGrey;

    return Scaffold(
      appBar: AppBar(
        title: Text(EnvConfig.appName), // Menampilkan Nama Dinamis Flavor Anti-AI
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch, 
              size: 100, 
              color: EnvConfig.isProduction ? Colors.amber : Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(
              EnvConfig.appName, 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Environment Mode: ${EnvConfig.environment}', 
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              'Base URL: ${EnvConfig.baseUrl}', 
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
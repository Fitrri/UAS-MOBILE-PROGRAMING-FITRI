import 'package:flutter/material.dart';
import '../../../../core/config/env_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil status apakah aplikasi sedang dalam mode gelap atau terang
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('UAS App [${EnvConfig.environment}]'),
        backgroundColor: EnvConfig.isProduction ? Colors.green : Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch, 
              size: 100, 
              color: isDark ? Colors.orangeAccent : Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              'Skeleton Project Siap!', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Base URL: ${EnvConfig.baseUrl}', 
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Mode Aplikasi: ${isDark ? "Dark Mode (NIM Ganjil)" : "Light Mode (NIM Genap)"}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
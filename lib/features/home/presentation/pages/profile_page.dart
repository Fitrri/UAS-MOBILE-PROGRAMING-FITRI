import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // WAJIB UNTUK METHOD CHANNEL
import 'package:lottie/lottie.dart'; // WAJIB UNTUK ANIMASI LOTTIE

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _clickCount = 0;
  bool _showLottie = false;

  // Deklarasi nama channel yang sinkron dengan MainActivity.kt
  static const platform = MethodChannel('com.fitri.uas/nim_channel');

  // FUNGSIONALITAS 1: Memicu Animasi Lottie Selama 3 Detik (Tantangan Anti-AI Poin 3)
  void _handleEasterEggClick() {
    setState(() {
      _clickCount++;
    });

    // Logika Khusus NIM Akhiran 0: Ketuk 10 kali secara cepat
    if (_clickCount >= 10) {
      setState(() {
        _clickCount = 0; // Reset hitungan
        _showLottie = true; // Munculkan animasi Lottie
      });

      // Sembunyikan kembali animasi secara otomatis setelah 3 detik sesuai regulasi soal
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showLottie = false;
          });
        }
      });
    }
  }

  // FUNGSIONALITAS 2: Memanggil Native Kotlin via Method Channel (Tantangan Anti-AI Poin 4)
  Future<void> _sendAndReverseNIM() async {
    try {
      // Mengirim String NIM Fitri ke sisi Native Kotlin
      final String result = await platform.invokeMethod('reverseNIM', {
        'nim': '20123020',
      });
      print("Respon sukses dari Kotlin: $result");
    } catch (e) {
      print("Gagal memanggil Method Channel Native: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D1B2A), // Sesuai tema PROD UTD Biru Gelap
      ),
      body: Stack(
        children: [
          // TAMPILAN UTAMA HALAMAN PROFIL
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Foto Profil (Bisa diketuk 10 kali untuk memicu Lottie)
                  GestureDetector(
                    onTap: _handleEasterEggClick,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueGrey[200],
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ketuk foto 10x untuk trigger Lottie Rahasia',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500], fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 32),
                  
                  // Kartu Informasi Mahasiswa
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.badge, color: Colors.blue),
                            title: Text('Nama Lengkap'),
                            subtitle: Text('Fitri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.pin, color: Colors.orange),
                            title: Text('NIM Mahasiswa'),
                            subtitle: Text('20123020', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TOMBOL KHUSUS METHOD CHANNEL NATIVE KOTLIN
                  ElevatedButton.icon(
                    onPressed: _sendAndReverseNIM,
                    icon: const Icon(Icons.android),
                    label: const Text('Kirim NIM ke Native Kotlin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // OVERLAY LAPISAN ANIMASI LOTTIE (AKAN MEMENUHI LAYAR SELAMA 3 DETIK)
          if (_showLottie)
            Container(
              color: Colors.black.withOpacity(0.8), // Efek background gelap di belakang animasi
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.asset(
                  'assets/celebration.json', // Pastikan file json sudah ditaruh di folder assets
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
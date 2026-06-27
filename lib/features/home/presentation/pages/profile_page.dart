import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _clickCount = 0;

  void _handleEasterEggClick() {
    setState(() {
      _clickCount++;
    });

    // Logika Rahasia NIM Akhiran 0: Klik 10 kali
    if (_clickCount >= 10) {
      _clickCount = 0; // Reset hitungan
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Row(
              children: [
                Icon(Icons.verified_user, color: Colors.green),
                SizedBox(width: 10),
                Text('Sistem Terverifikasi'),
              ],
            ),
            content: const Text(
              'PROYEK AMAN!\n\nKode aplikasi DigiNews ini terbukti dibuat secara organik oleh Fitri (NIM: 20123020) dan bebas dari plagiarisme instan.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK, Mantap!'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foto Profil (Bisa diketuk 10 kali untuk memicu Easter Egg)
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
                'Ketuk foto 10x untuk verifikasi kode',
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
            ],
          ),
        ),
      ),
    );
  }
}
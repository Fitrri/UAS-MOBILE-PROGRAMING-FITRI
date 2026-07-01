import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🟢 WAJIB: Memori Lokal

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _clickCount = 0;
  bool _showLottie = false;
  File? _imageFile;

  static const platform = MethodChannel('com.fitri.uas/nim_channel');
  final ImagePicker _picker = ImagePicker();
  final String currentEnv = const String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');

  // 🎨 THEME COLORS
  Color get _primaryColor => currentEnv == 'PROD' ? const Color(0xFF0F2027) : const Color(0xFF37474F);
  Color get _accentColor => currentEnv == 'PROD' ? const Color(0xFF203A43) : const Color(0xFF455A64);
  Color get _highlightColor => currentEnv == 'PROD' ? const Color(0xFF2C5364) : const Color(0xFF78909C);
  Color get _badgeColor => currentEnv == 'PROD' ? const Color(0xFF00E5FF) : const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _loadSavedImage(); // 🟢 Ambil foto yang tersimpan di memori saat halaman pertama dibuka
  }

  // 💾 FUNGSI 1: Memuat Foto Profil dari Memori Lokal HP
  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('saved_profile_path');
    if (imagePath != null && imagePath.isNotEmpty) {
      if (await File(imagePath).exists()) {
        setState(() {
          _imageFile = File(imagePath);
        });
      }
    }
  }

  // 💾 FUNGSI 2: Mengambil Gambar & Menguncinya ke Memori Lokal
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        // 🟢 Kunci path foto ke dalam SharedPreferences agar permanen
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_profile_path', pickedFile.path);
      }
    } catch (e) {
      print("Gagal mengambil gambar: $e");
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Wrap(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    width: 40, height: 5,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'PERBARUI FOTO PROFIL',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: _primaryColor),
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(backgroundColor: _primaryColor.withOpacity(0.1), child: Icon(Icons.camera_alt, color: _primaryColor)),
                  title: const Text('Buka Kamera Utama', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: CircleAvatar(backgroundColor: _primaryColor.withOpacity(0.1), child: Icon(Icons.photo_library, color: _primaryColor)),
                  title: const Text('Pilih dari Galeri Album', style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleEasterEggClick() {
    setState(() {
      _clickCount++;
    });
    if (_clickCount >= 10) {
      setState(() {
        _clickCount = 0;
        _showLottie = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showLottie = false;
          });
        }
      });
    }
  }

  Future<void> _sendAndReverseNIM() async {
    try {
      final String result = await platform.invokeMethod('reverseNIM', {
        'nim': '20123020',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Native Kotlin Terbalik: $result'),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print("Gagal memanggil Method Channel Native: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text(
          'PROFIL PENGEMBANG ($currentEnv)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _accentColor, _highlightColor],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _handleEasterEggClick,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                            child: _imageFile == null
                                ? Icon(Icons.account_circle, size: 122, color: _highlightColor)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showPickerOptions(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _badgeColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.camera_enhance, size: 18, color: Color(0xFF0F2027)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '⚡ Ketuk foto profil 10x untuk kejutan rahasia',
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9), fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 10)),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildInfoTile(Icons.person_pin, 'Nama Lengkap', 'Fitri Anisa', Colors.blueAccent),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1, thickness: 0.5),
                        ),
                        _buildInfoTile(Icons.pin_sharp, 'NIM Mahasiswa', '20123020', Colors.deepOrangeAccent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_primaryColor, _highlightColor]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: _primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _sendAndReverseNIM,
                      icon: const Icon(Icons.android, color: Colors.white),
                      label: const Text(
                        'KIRIM NIM KE NATIVE KOTLIN',
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showLottie)
            Container(
              color: Colors.black.withOpacity(0.8),
              width: double.infinity, height: double.infinity,
              child: Center(
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_myej6wbc.json',
                  width: 320, height: 320, fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.emoji_events, size: 140, color: Colors.amber);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            ],
          ),
        ),
      ],
    );
  }
}
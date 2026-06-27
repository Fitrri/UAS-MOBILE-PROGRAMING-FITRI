import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Wajib dipanggil jika menggunakan proses async sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menjalankan & menunggu setup Dependency Injection selesai
  await setupLocator();
  
  runApp(const FinalProjectApp());
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  // GANTI DENGAN NIM ASLI ANDA UNTUK LOGIKA DINAMIS ANTI-PLAGIASI
  final String myNim = '20123020'; // Sudah disesuaikan dengan NIM Fitri

  @override
  Widget build(BuildContext context) {
    final useDarkMode = AppTheme.isDarkMode(myNim);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UAS Mobile Lanjut',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: useDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
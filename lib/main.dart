import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Wajib dipanggil jika menggunakan proses async sebelum runApp [cite: 143]
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menjalankan & menunggu setup Dependency Injection selesai [cite: 145, 146]
  await setupLocator();
  
  runApp(const FinalProjectApp()); // [cite: 147]
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  // GANTI DENGAN NIM ASLI ANDA UNTUK LOGIKA DINAMIS ANTI-PLAGIASI
  final String myNim = '211011400124'; 

  @override
  Widget build(BuildContext context) {
    final useDarkMode = AppTheme.isDarkMode(myNim);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UAS Mobile Lanjut', // [cite: 154]
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: useDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';

class NewsHomePage extends StatelessWidget {
  const NewsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Inisialisasi Warna Sesuai Environment & Screenshot Kamu
    final Color mainHeaderColor = EnvConfig.isProduction 
        ? const Color(0xFF0D1B2A) 
        : const Color(0xFF3E4A56); // Warna abu-abu gelap khas DEV mode

    final Color badgeColor = EnvConfig.isProduction 
        ? const Color(0xFF00A896) // Hijau toska PROD
        : const Color(0xFFE0A96D); // Kuning/Orange DEV

    final String modeText = EnvConfig.isProduction ? "PROD MODE" : "DEV MODE";
    
    // Ambil parameter nama depan & NIM dari Config bawaan project kamu
    final String namaDepan = EnvConfig.isProduction ? "Fitri" : "Fitri"; 
    final String nimAtauNama = EnvConfig.isProduction ? "20123020" : "Fitri";

    return BlocProvider(
      // 🚀 Logika pengambilan data yang sudah berhasil (TETAP DIPERTAHANKAN)
      create: (_) => locator<NewsCubit>()..fetchNews(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9), // Background abu-abu sangat soft
        body: SafeArea(
          top: false, // Biar warna header menembus status bar atas seperti di foto
          child: Column(
            children: [
              // 🟦 1. TAMPILAN HEADER CUSTOME MELENGKUNG (PERSIS SEPERTI DI SCREENSHOT)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                decoration: BoxDecoration(
                  color: mainHeaderColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Pertama: Icon Menu, Judul, dan Profil
                    Row(
                      children: [
                        const Icon(Icons.newspaper_rounded, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            EnvConfig.isProduction 
                                ? "UTD - $nimAtauNama" 
                                : "DEV - $namaDepan",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push('/profile'),
                          child: const Icon(Icons.account_circle, color: Colors.white, size: 32),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Baris Kedua: Selamat Datang & Badge Mode Side-by-Side
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang Kembali,",
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$namaDepan ✨",
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // Badge Bulat Lonjong (PROD MODE / DEV MODE)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: badgeColor, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            modeText,
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 📦 2. AREA DAFTAR BERITA (MENGGUNAKAN BLOCBUILDER)
              Expanded(
                child: BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainHeaderColor)));
                    } else if (state is NewsLoaded) {
                      if (state.articles.isEmpty) {
                        return const Center(child: Text('Tidak ada berita saat ini.'));
                      }
                      
                      return RefreshIndicator(
                        onRefresh: () => context.read<NewsCubit>().fetchNews(),
                        color: mainHeaderColor,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.articles.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final article = state.articles[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              height: 100, // Ukuran tinggi aman agar tidak crash/blank putih
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Row(
                                  children: [
                                    // Garis vertikal indikator warna di samping kiri card
                                    Container(width: 4, color: badgeColor),
                                    // Tampilan Gambar Berita
                                    SizedBox(
                                      width: 105,
                                      height: 100,
                                      child: _buildArticleImage(article.urlToImage, 100),
                                    ),
                                    // Teks Judul & Deskripsi Berita
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              article.title,
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              article.description ?? 'Tidak ada deskripsi berkas.',
                                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is NewsError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent),
                              const SizedBox(height: 8),
                              Text(
                                'Gagal memuat berita:\n${state.message}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget Gambar agar aman tidak rusak/eror layout
  Widget _buildArticleImage(String? url, double height) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(height, Icons.broken_image),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            color: Colors.grey[100],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      );
    }
    return _buildFallbackImage(height, Icons.image);
  }

  Widget _buildFallbackImage(double height, IconData icon) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFECEFF1),
      child: Icon(icon, size: 28, color: Colors.grey[400]),
    );
  }
}
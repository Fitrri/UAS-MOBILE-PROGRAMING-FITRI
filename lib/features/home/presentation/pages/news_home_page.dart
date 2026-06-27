import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/injection.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';

class NewsHomePage extends StatelessWidget {
  const NewsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menentukan warna utama secara dinamis berdasarkan Mode Environment (Syarat Soal Hal 1)
    final Color appBarColor = EnvConfig.isProduction 
        ? const Color(0xFF0D1B2A) // Biru Gelap untuk PROD
        : Colors.blueGrey;        // Abu-abu Kebiruan untuk DEV

    return BlocProvider(
      // Mengambil instance NewsCubit dari Dependency Injection GetIt
      create: (_) => locator<NewsCubit>()..fetchNews(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(EnvConfig.appName), // Menampilkan "DEV - Fitri" atau "UTD - 20123020"
          backgroundColor: appBarColor,
          elevation: 2,
        ),
        body: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsLoaded) {
              if (state.articles.isEmpty) {
                return const Center(child: Text('Tidak ada berita saat ini.'));
              }
              return RefreshIndicator(
                onRefresh: () => context.read<NewsCubit>().fetchNews(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    final article = state.articles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article.description ?? 'Tidak ada deskripsi berkas.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gagal memuat berita:\n${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<NewsCubit>().fetchNews(),
                        child: const Text('Coba Lagi'),
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
    );
  }
}
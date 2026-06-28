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
    final Color appBarColor = EnvConfig.isProduction 
        ? const Color(0xFF0D1B2A) 
        : Colors.blueGrey;        

    return BlocProvider(
      create: (_) => locator<NewsCubit>()..fetchNews(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(EnvConfig.appName), 
          backgroundColor: appBarColor,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, size: 28),
              onPressed: () {
                GoRouter.of(context).push('/profile');
              },
            ),
            const SizedBox(width: 8),
          ],
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
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. TAMPILAN GAMBAR UTAMA DARI API
                          if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                            Image.network(
                              article.urlToImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 180,
                                  color: Colors.grey[100],
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                            )
                          else
                            Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.blueGrey[50],
                              child: const Icon(Icons.image, size: 40, color: Colors.grey),
                            ),

                          // 2. TAMPILAN TEKS JUDUL DAN DESKRIPSI
                          Padding(
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
                        ],
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
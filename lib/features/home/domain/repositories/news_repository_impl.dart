import '../../domain/repositories/news_repository.dart';
import '../data_sources/news_remote_data_source.dart';
import '../data_sources/news_local_data_source.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ArticleModel>> getArticles() async {
    try {
      // 1. Coba ambil data dari internet dulu
      final remoteArticles = await remoteDataSource.getTopHeadlines();
      
      // 2. Simpan ke database lokal Isar buat mode offline
      await localDataSource.cacheArticles(remoteArticles);
      
      // 3. LOGIKA ANTI-AI NIM AKHIRAN 0: Urutkan A-Z (Ascending) berdasarkan Judul
      remoteArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      
      return remoteArticles;
    } catch (e) {
      // 4. Kalau internet mati / error, otomatis ambil data terakhir dari Isar (Offline Mode)
      final localArticles = await localDataSource.getCachedArticles();
      
      // Tetap lakukan sorting A-Z pada data offline sesuai syarat dosen
      localArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      
      return localArticles;
    }
  }
}
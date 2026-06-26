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
      final remoteArticles = await remoteDataSource.getTopHeadlines();
      await localDataSource.cacheArticles(remoteArticles);
      
      // LOGIKA ANTI-AI NIM AKHIRAN 0: Urutkan A-Z (Ascending) berdasarkan Judul
      remoteArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      
      return remoteArticles;
    } catch (e) {
      final localArticles = await localDataSource.getCachedArticles();
      localArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      return localArticles;
    }
  }
}
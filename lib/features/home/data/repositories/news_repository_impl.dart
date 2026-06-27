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
  Future<List<ArticleModel>> getNews() async {
    // Memanggil remote data source (Dio/Internet)
    final articles = await remoteDataSource.getNews();
    
    // Otomatis simpan ke lokal database setelah berhasil ambil dari internet
    for (var article in articles) {
      await localDataSource.saveArticle(article);
    }
    
    return articles;
  }

  @override
  Future<List<ArticleModel>> getLocalNews() async {
    // Memanggil local data source (Isar DB) saat offline
    return await localDataSource.getCachedNews();
  }
}
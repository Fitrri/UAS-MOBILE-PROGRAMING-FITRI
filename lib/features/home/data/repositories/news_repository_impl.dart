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
    // 1. Ambil data asli dari internet via Remote DataSource
    final articles = await remoteDataSource.getTopHeadlines();
    
    // 2. Langsung amankan data internet tersebut ke dalam Cache Isar Database
    await localDataSource.cacheArticles(articles);
    
    return articles;
  }

  @override
  Future<List<ArticleModel>> getLocalNews() async {
    // 3. Ambil data cadangan dari Local DataSource (Isar DB) saat offline
    return await localDataSource.getCachedArticles();
  }
}
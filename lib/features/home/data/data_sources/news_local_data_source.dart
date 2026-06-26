import 'package:isar/isar.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Isar isar;

  NewsLocalDataSourceImpl({required this.isar});

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    // Membaca data berita yang tersimpan di dalam memori HP
    return await isar.articleModels.where().findAll();
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    // Menyimpan data berita baru ke database Isar secara aman
    await isar.writeTxn(() async {
      await isar.articleModels.clear(); // Hapus cache berita lama
      await isar.articleModels.putAll(articles); // Masukkan berita baru
    });
  }
}
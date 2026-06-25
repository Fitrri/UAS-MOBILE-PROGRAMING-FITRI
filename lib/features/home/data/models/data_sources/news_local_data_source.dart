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
    // Ambil data yang tersimpan di lokal Isar database
    return await isar.articleModels.where().findAll();
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    // Simpan data baru ke Isar, hapus cache lama biar ga numpuk
    await isar.writeTxn(() async {
      await isar.articleModels.clear();
      await isar.articleModels.putAll(articles);
    });
  }
}
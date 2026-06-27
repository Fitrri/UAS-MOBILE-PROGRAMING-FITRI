import '../../data/models/article_model.dart';

abstract class NewsRepository {
  // Fungsi untuk ambil berita dari internet
  Future<List<ArticleModel>> getNews();

  // Fungsi untuk ambil berita dari database lokal Isar
  Future<List<ArticleModel>> getLocalNews();
}
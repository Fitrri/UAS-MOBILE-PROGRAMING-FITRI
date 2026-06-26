import '../entities/article_entity.dart'; // Kita asumsikan Entity berita nanti di sini

abstract class NewsRepository {
  Future<List<ArticleModel>> getArticles();
}
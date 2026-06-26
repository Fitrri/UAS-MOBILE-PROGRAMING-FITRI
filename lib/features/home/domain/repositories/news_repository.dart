// Kita import langsung ArticleModel dengan relative path mundur 1 kali ke folder home/
import '../../data/models/article_model.dart';

abstract class NewsRepository {
  Future<List<ArticleModel>> getArticles();
}
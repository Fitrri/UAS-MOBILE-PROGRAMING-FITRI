import 'package:isar/isar.dart';

part 'article_model.g.dart';

@collection
class ArticleModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  final String? url;

  final String? title;
  final String? author;
  final String? description;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  ArticleModel({
    this.url,
    this.title,
    this.author,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      url: json['url'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      description: json['description'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }
}
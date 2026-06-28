import 'package:dio/dio.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl({required this.dio});

 @override
  Future<List<ArticleModel>> getTopHeadlines() async {
    try {
      // Ganti ke endpoint top headlines kategori bisnis/umum agar datanya selalu penuh
      final response = await dio.get('top-headlines?category=business&apiKey=cc35bccefd0f4841a5176aead5882f87');
      
      if (response.statusCode == 200) {
        final List data = response.data['articles'] ?? [];
        return data.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data dari server');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
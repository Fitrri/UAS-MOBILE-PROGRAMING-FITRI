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
      // Mengambil berita utama dari API lokal/publik
      final response = await dio.get('top-headlines?country=id&apiKey=API_KEY_KAMU');
      
      if (response.statusCode == 200) {
        final List data = response.data['articles'] ?? [];
        return data.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw Exception('gagal mengambil data dari server');
      }
    } catch (e) {
      throw Exception('terjadi kesalahan jaringan: $e');
    }
  }
}
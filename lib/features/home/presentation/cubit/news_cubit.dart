import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/article_model.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  NewsCubit({required this.repository}) : super(NewsInitial());

  Future<void> fetchNews() async {
    emit(NewsLoading());
    try {
      // 1. Ambil dari internet
      final List<ArticleModel> fetchedArticles = await repository.getNews();
      
      // Urutkan A-Z
      fetchedArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      
      emit(NewsLoaded(articles: fetchedArticles));
    } catch (e) {
      try {
        // 2. OFFLINE MODE: Jika internet mati, ambil data dari database lokal Isar
        final List<ArticleModel> localArticles = await repository.getLocalNews();
        
        if (localArticles.isNotEmpty) {
          localArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          emit(NewsLoaded(articles: localArticles));
        } else {
          emit(NewsError(message: "Koneksi internet terputus & database lokal masih kosong."));
        }
      } catch (localError) {
        emit(NewsError(message: "Gagal memuat data: $e"));
      }
    }
  }
}
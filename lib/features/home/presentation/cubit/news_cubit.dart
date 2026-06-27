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
      // 1. Ambil data berita asli dari internet
      final List<ArticleModel> fetchedArticles = await repository.getNews();

      // 2. LOGIKA NIM AKHIRAN 0: Urutkan berita secara Ascending (A-Z)
      fetchedArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

      emit(NewsLoaded(articles: fetchedArticles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }
}
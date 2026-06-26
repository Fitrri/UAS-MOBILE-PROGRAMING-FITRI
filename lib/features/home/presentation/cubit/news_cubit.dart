import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  NewsCubit({required this.repository}) : super(NewsInitial());

  Future<void> fetchNews() async {
    emit(NewsLoading());
    try {
      // Memanggil repo yang sudah tertanam logika sorting NIM akhiran 0 kamu
      final articles = await repository.getArticles();
      emit(NewsLoaded(articles: articles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }
}
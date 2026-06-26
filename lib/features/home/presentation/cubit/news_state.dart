import '../../data/models/article_model.dart';

abstract class NewsState {}

// 1. Kondisi awal pas aplikasi baru dibuka
class NewsInitial extends NewsState {}

// 2. Kondisi pas aplikasi lagi loading muter-muter nyari berita
class NewsLoading extends NewsState {}

// 3. Kondisi pas data berita BERHASIL diambil (dan udah di-sort A-Z otomatis)
class NewsLoaded extends NewsState {
  final List<ArticleModel> articles;
  NewsLoaded({required this.articles});
}

// 4. Kondisi pas jaringan bapuk alias error
class NewsError extends NewsState {
  final String message;
  NewsError({required this.message});
}
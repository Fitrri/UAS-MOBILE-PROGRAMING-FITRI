import 'package:flutter_bloc/flutter_bloc.dart';
// WAJIB IMPORT INI: Mengenalkan ArticleModel ke dalam berkas Cubit
import '../../data/models/article_model.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  NewsCubit({required this.repository}) : super(NewsInitial());

  Future<void> fetchNews() async {
    emit(NewsLoading());
    try {
      // Kita tambahkan <ArticleModel> agar tipenya tidak dianggap List<dynamic>
      final dummyArticles = <ArticleModel>[
        ArticleModel(title: 'Zebra Ragam Manfaat', description: 'Mengenal fauna unik bermotif garis hitam putih.'),
        ArticleModel(title: 'Edukasi Gadget pada Anak', description: 'Tips membatasi screen time pada anak usia dini.'),
        ArticleModel(title: 'Bandung Lautan Api', description: 'Mengenang sejarah peristiwa perjuangan di Jawa Barat.'),
        ArticleModel(title: 'Kuliner Nusantara yang Mendunia', description: 'Rendang dan sate menjadi favorit para turis.'),
      ];

      // LOGIKA NIM AKHIRAN 0: Mengurutkan data secara Ascending (A-Z) berdasarkan judul
      dummyArticles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

      // Simulasi jeda loading 1 detik biar estetik
      await Future.delayed(const Duration(seconds: 1));
      
      emit(NewsLoaded(articles: dummyArticles));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }
}
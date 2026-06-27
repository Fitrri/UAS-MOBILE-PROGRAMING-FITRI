import 'package:go_router/go_router.dart';
// Ganti import lama ke file news_home_page.dart kita yang baru
import '../../features/home/presentation/pages/news_home_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        // Builder diubah dari HomePage() menjadi NewsHomePage()
        builder: (context, state) => const NewsHomePage(),
      ),
    ],
  );
}
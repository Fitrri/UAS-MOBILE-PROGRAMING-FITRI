import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/news_home_page.dart';

import '../../features/home/presentation/pages/profile_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const NewsHomePage(),
      ),
      
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
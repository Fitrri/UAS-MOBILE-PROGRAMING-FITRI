import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../config/env_config.dart';
import '../../features/home/data/models/article_model.dart';
import '../../features/home/data/data_sources/news_remote_data_source.dart';
import '../../features/home/data/data_sources/news_local_data_source.dart';
// Import relative path untuk repository baru kamu
import '../../features/home/domain/repositories/news_repository.dart';
import '../../features/home/data/repositories/news_repository_impl.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Register Isar (Database Offline)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ArticleModelSchema], 
    directory: dir.path,
  );
  locator.registerSingleton<Isar>(isar);

  // 2. Register Dio (Network API)
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 3. Register Data Sources (Remote & Local)
  locator.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dio: locator()),
  );
  locator.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(isar: locator()),
  );

  // 4. Register Repository (Dengan Logika Sorting A-Z)
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
}
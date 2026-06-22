import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uas_mobile_lanjut/features/home/data/models/article_model.dart';
import '../config/env_config.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Register Isar (Database Offline)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ArticleModelSchema], // Schema hasil generate dari build_runner
    directory: dir.path,
  );
  locator.registerSingleton<Isar>(isar);

  // 2. Register Dio (Network API)
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    // Menambahkan logger standar untuk memantau request API
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });
}
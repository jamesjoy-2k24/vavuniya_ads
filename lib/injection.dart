import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'domain/repositories/auth_repository.dart';
import 'data/repositories/auth_repository_impl.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(
      () => Dio(BaseOptions(baseUrl: 'http://localhost:3000/vavuniya-ads')));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<Dio>()));
}

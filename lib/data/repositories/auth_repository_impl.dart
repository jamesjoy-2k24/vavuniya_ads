import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<UserModel> login(String email, String password) async {
    final response =
        await _dio.post('/login', data: {'email': email, 'password': password});
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await _dio.post('/logout');
  }
}

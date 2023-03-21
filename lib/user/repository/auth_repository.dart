import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/login_response.dart';
import 'package:actual/common/model/token_response.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  final dio = ref.watch(dioProvider);

    return AuthRepository(dio: dio, baseUrl: 'http:/$ipAndroid/auth');
  }
);

class AuthRepository{
  //http://$ipAndrid/auth
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.dio,
    required this.baseUrl,
  });

  Future<LoginResponse>login({
    required String username,
    required String password,
}) async {
    final serializaed = DataUtils.plainToBase64('$username : $password');

    final resp = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {
          'authorization' : 'Basic $serializaed',
        },
      ),
    );

    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async{
    final resp = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {
          'refreshToken' : 'true',
        },
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
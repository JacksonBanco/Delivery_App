import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  //전체가 토큰을 자동으로 적용하는코드
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.ref,
    required this.storage,
  });

  // 1 요청을 보낼때
  //요청이 보내질때마다 만약에 요청의 Header에 accessToken: true라는 값이 있다면(restaurant_repository.dart)파일
  //실제 토큰을 가져와서 (storage에서) 'authorization' : 'Bearer $token'으로 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      //요청을 보내기전 헤더를 삭제하고  밑에 addAll구문으로 헤더를 더해줘서 실제 토큰값을 받아옴
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      //요청을 보내기전 헤더를 삭제하고  밑에 addAll구문으로 헤더를 더해줘서 실제 토큰값을 받아옴
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    // TODO: implement onRequest 이 전 코드는 요청이 보내기전임임
    return super.onRequest(options, handler); //리턴을 해야 요청이 됨
  }

  // 2 응답을 받을때

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    // TODO: implement onResponse
    return super.onResponse(response, handler);
  }

  // 3 에러가 났을때
  //
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    // TODO: implement onError
    //401 에러가 났을때 (status code 토큰이 잘못됐을때 예}토큰시간 만료)
    //토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    //다시 새로운 토큰으로 요청을한다.

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 없으면 당연히ㅑ 에러를 던진다
    //이게 에러를 던지는 코드  에러를 던질때는  handler.reject(err) 사용한다
    if (refreshToken == null) {
      return handler.reject(err);
    }
    //401 잘못된 토큰이다 라는 에러 코드
    final isStates401 = err.response?.statusCode == 401;
    //이게 실행되지않으면  Refresh토큰이 문제있음
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStates401 && isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ipAndroid/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        //토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch (e) {
        //circular dependency error
        // userMeProvider -> dio -> userMeProvider -> dio -> ...
        ref.read(authProvider.notifier).logout();
        
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}

import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //처음 실행할때 initState이 실행되면서 checkToken을 체크할동안
    //스플레쉬 화면은 계속보여주게 할거임
    checkToken();
    //토큰을 다 지우기때문에
   // deleteToken();
  }
    void deleteToken() async {
      final storage = ref.read(secureStorageProvider);

    await storage.deleteAll();
    }

    void checkToken() async{
      final storage = ref.read(secureStorageProvider);

      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
      final accessToken =  await storage.read(key: ACCESS_TOKEN_KEY);

      final dio = Dio();

      try{
        //회원가입 버튼
        final resp = await dio.post(
          'http://$ipAndroid/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data[accessToken]);

        //토큰이 둘중 하나라도 null또는 틀릴경우 로그인화면으로 이동
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RootTab(),
          ),
              (route) => false,
        );

      }catch(e){
        //여기로 가는기유가 둘다 토큰이있고 이미 로그인을한상태이기때문에
        //토큰을 발급받아서 이미 저장되어있기때문에
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
              (route) => false,
        );
      }
    }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'sfsdfsf',
      bottomNavigationBar: null,
      backgroundColor: PRIMARY_COlOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width /2,
            ),
            const SizedBox(height: 16.0,),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

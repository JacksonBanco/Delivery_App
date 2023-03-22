import 'dart:convert';
import 'dart:io';

import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    //localHost 에뮬레이터 기준
    final emulatorIp = '10.0.2.2:3000';
    final simulatorIp = '127.0.0.1:3000';

    final ipIos = Platform.isIOS ? simulatorIp : emulatorIp;
    final ipAndroid = Platform.isAndroid ? simulatorIp : emulatorIp;

    return DefaultLayout(
      bottomNavigationBar: null,
      backgroundColor: Colors.white,
      title: 'my Delivery app',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Title(),
                SizedBox(
                  height: 20,
                ),
                _SubTitle(),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 1,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                  obscureText: false,
                  autofocus: true,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                  autofocus: false,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      //로그인 도중 로그인 버튼 못누르게 하기
                      onPressed: state is UserModelLoading ? null :
                          () async {
                        ref.read(userMeProvider.notifier).login(
                              username: username,
                              password: password,
                            );

                        /* //ID:비밀번호
                          final rawString = '$username:$password';

                          //Base 64 인코딩 하는법 그냥 외우기
                          Codec<String, String> stringToBase64 = utf8.fuse(
                              base64);

                          String token = stringToBase64.encode(rawString);

                          //로그인하는 로직직
                         final resp = await dio.post('http://$ipAndroid/auth/login',
                            options: Options(
                              headers: {
                                'authorization': 'Basic $token',
                              },
                            ),
                          );

                          final refreshToken = resp.data['refreshToken'];
                          final accessToken = resp.data['accessToken'];

                          final storage = ref.read(secureStorageProvider);

                          await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                          await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => RootTab(),
                            ),
                        );*/
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COlOR,
                      ),
                      child: Text('로그인'),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    TextButton(
                      onPressed: () async {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text('회원가입'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome To Delivery World',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.blue,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Please enter your email and password and log in! \n Have a delicious meal! :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}

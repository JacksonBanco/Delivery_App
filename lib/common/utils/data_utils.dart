import 'dart:convert';

import 'package:actual/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ipAndroid$value';
  }

  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain){
    //Base 64 인코딩 하는법 그냥 외우기
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}
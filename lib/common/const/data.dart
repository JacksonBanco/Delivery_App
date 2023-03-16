import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY ='ACCESS_TOKEN_KEY';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN_KEY';

//localHost 에뮬레이터 기준
final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

final ipIos = Platform.isIOS ? simulatorIp : emulatorIp;
final ipAndroid = Platform.isAndroid ? simulatorIp : emulatorIp;


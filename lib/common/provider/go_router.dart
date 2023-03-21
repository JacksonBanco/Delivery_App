import 'package:actual/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  //read로 하는 이유: 한번만 읽고 값이 변경되도 다시 빌드하지않기때문에
  //항상 같은  GoRouter정보를 빌드해야되기때문에
  final provider = ref.read(authProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogin,
    );
  }
);

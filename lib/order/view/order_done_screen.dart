import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'order_done';

  const OrderDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              color: PRIMARY_COlOR,
              size: 50.0,
            ),
            const SizedBox(
              height: 32.0,
            ),
            AlertDialog(
              content: Text(
                '결제가 완료되었습니다.',
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COlOR,
                  ),
                  child: Text('뒤로가기 '),
                ),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              onPressed: () {
                context.goNamed(RootTab.routeName);
              },
              child: Text(
                'home',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

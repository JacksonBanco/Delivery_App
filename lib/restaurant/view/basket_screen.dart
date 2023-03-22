import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/order/view/order_done_screen.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return AlertDialog(
        content: Text('장바구니가 비어있습니다'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('뒤로가기'),
          ),
        ],
      );
    }

    final productsTotal = basket.fold<int>(
      0,
      (p, n) => p + (n.product.price * n.count),
    );

    final productsDeliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: 'basket',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return Divider(
                      height: 32.0,
                    );
                  },
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onPlus: () {
                        ref.read(basketProvider.notifier).addToBasket(
                              product: model.product,
                            );
                      },
                      onMinus: () {
                        ref.read(basketProvider.notifier).removeFromBasket(
                              product: model.product,
                            );
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(productsTotal.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      if (basket.length > 0)
                        Text(productsDeliveryFee.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총액',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        (productsTotal + productsDeliveryFee).toString(),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COlOR,
                      ),
                      onPressed: () async {
                        final resp =
                            await ref.read(orderProvider.notifier).postOrder();
                        if (resp) {
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('결제 실패!'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '결제하기',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

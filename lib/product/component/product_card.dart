import 'package:actual/common/const/colors.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final String id;
  final Image image;
  final String name;
  final String detail;
  final int price;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const ProductCard({
    required this.id,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    this.onPlus,
    this.onMinus,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onPlus,
    VoidCallback? onMinus,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onMinus: onMinus,
      onPlus: onPlus,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onPlus,
    VoidCallback? onMinus,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onMinus: onMinus,
      onPlus: onPlus,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'asset/img/food/ddeok_bok_gi.jpg',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: PRIMARY_COlOR,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      '${price}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: PRIMARY_COlOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if(onMinus != null && onPlus != null)
        _Footer(
          total: (basket.firstWhere((e) => e.product.id == id).count *
                 basket.firstWhere((e) => e.product.id == id).product.price)
              .toString(),
          count: basket.firstWhere((e) => e.product.id == id).count,
          onMinus: onMinus!,
          onPlus: onPlus!,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _Footer(
      {required this.total,
      required this.count,
      required this.onMinus,
      required this.onPlus,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 $total',
            style: TextStyle(
              color: PRIMARY_COlOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(
              icon: Icons.remove,
              onTap: onMinus,
            ),
            Text(
              count.toString(),
              style: TextStyle(
                color: PRIMARY_COlOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            renderButton(
              icon: Icons.add,
              onTap: onPlus,
            ),
          ],
        ),
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: PRIMARY_COlOR,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COlOR,
        ),
      ),
    );
  }
}

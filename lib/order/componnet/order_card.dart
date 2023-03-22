import 'package:actual/common/const/colors.dart';
import 'package:actual/order/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productsDetail;
  final int price;

  const OrderCard(
      {required this.price,
      required this.name,
      required this.image,
      required this.orderDate,
      required this.productsDetail,
      Key? key})
      : super(key: key);

  factory OrderCard.fromModel({
    required OrderModel model,
  }) {
    final productsDetail = model.products.length < 2
        ? model.products.first.product.name :
       '${model.products.first.product.name} 외 ${model.products.length -1 }개 ';

    return OrderCard(
      price: model.totalPrice,
      name: model.restaurant.name,
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50,
        width: 50,
      ),
      orderDate: model.createdAt,
      productsDetail: productsDetail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}'
          '.${orderDate.day.toString().padLeft(2, '0')}'
          ' - ${orderDate.hour} : ${orderDate.minute} 주문완료',
        ),
        const SizedBox(
          width: 16.0,
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '$productsDetail $price',
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  //이미지
  final Widget image;
  //레스토랑 이름
  final String name;
  //레스토랑 태그
  final List<String> tags;
  //평점 점수
  final int ratingsCount;
  //배송걸리는 시간
  final int deliveryTime;
  //배송 수수료
  final int deliveryFee;
  //평균 평점
  final double ratings;
  //상세 레스토랑카드 여부
  final bool isDetail;
  //상세내용
  final String? detail;

  const RestaurantCard(
      {required this.name,
      required this.image,
      required this.deliveryFee,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.ratings,
      required this.tags,
      this.isDetail = false,
      this.detail,
      Key? key})
      : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }){
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        //박스 전체를 차지하는 파라미터 fit
        fit: BoxFit.cover,
      ),
      name: model.name,
      deliveryFee: model.deliveryFee,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      ratings: model.ratings,
      //전에 에러가 난 이유? -> tags정의할때 List<String>으로 정의 했는데 위에 방식대로 똑같이할경우
      //List<dynamic>형태로 값이 들어가기때문에 타입이 다르기때문에 에러가 남
      tags: model.tags,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //여기 if문을 사용한다면  ClipRRect여기 구문까지만 적용됨
        if(isDetail)
          image,
        if(!isDetail)
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: image,
        ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                tags.join('・'),
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                  ),
                ],
              ),
              if(detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(detail!),
                ),
            ],
          ),
        )
      ],
    );
  }
}

 Widget renderDot() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      '・',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12.0
      ),
    ),
  );
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({required this.label, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COlOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

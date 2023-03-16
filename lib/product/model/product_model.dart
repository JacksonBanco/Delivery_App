import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId{
  final String id;
  //상품 이름
  final String name;
  //상품 상세정보
  final String detail;
  // 이미지 URL
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  //상품 가격
  final int price;
  //레스토랑 정보 꼭 있어야되는이유는? 상품을 눌렀을경우 상품상세페이지로 이동하기때문에 거기정보를 받아오기위해서
  final RestaurantModel Restaurant;

  ProductModel({
    required this.id,
    required this.detail,
    required this.imgUrl,
    required this.name,
    required this.price,
    required this.Restaurant,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
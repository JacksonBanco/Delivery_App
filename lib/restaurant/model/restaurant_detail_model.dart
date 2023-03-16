import 'package:actual/common/utils/data_utils.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';


part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.deliveryFee,
    required super.deliveryTime,
    required super.ratingsCount,
    required this.detail,
    required this.products,
  });


  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantDetailModelFromJson(json);
 /* factory RestaurantDetailModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantDetailModel(
      id: json['id'],
      name: json['name'],
      thumbUrl: 'http://$ipAndroid${json['thumbUrl']}',
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantpriceRange.values.firstWhere(
        (e) => e.name == json['priceRange'],
      ),
      ratings: json['ratings'],
      deliveryFee: json['deliveryFee'],
      deliveryTime: json['deliveryTime'],
      ratingsCount: json['ratingsCount'],
      detail: json['detail'],
      products: json['products']
          .map<RestaurantProductModel>(
          (x) => RestaurantProductModel.fromModel(
            json: x,
          ),
      ).toList(),
    );
  }*/
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });
  factory RestaurantProductModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantProductModelFromJson(json);
}

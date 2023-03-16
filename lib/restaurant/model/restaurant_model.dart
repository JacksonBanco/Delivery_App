import 'package:actual/common/const/data.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantpriceRange{
  expensive,
  medium,
  cheep,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantpriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;


  RestaurantModel({
  required this.id,
  required this.name,
  required this.thumbUrl,
  required this.tags,
  required this.priceRange,
  required this.ratings,
  required this.deliveryFee,
  required this.deliveryTime,
  required this.ratingsCount,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantModelFromJson(json);

  //this 현재 인스턴스
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  static pathToUrl(String value){
    return 'http://$ipAndroid$value';
  }

/*  //from 생성자(constructors)
  factory RestaurantModel.fromJson({
    //list가 아니라고 json으로 값을 받아온다면 String, dynamic으로 표현한다
    //json == item
    required Map<String, dynamic> json,
}){
    //factory 생성자(constructors)를 만든이유 : json을 넣기만하면 자동적으로 매핑해줌
    return RestaurantModel(
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
    );
  }*/
}
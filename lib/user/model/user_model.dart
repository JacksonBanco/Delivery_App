import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

//부모 빈 클래스
abstract class UserModelBase{}

//에러상태
class UserModelError extends UserModelBase{
  final String message;
  UserModelError({
    required this.message,
});
}

//로딩중
class UserModelLoading extends UserModelBase{

}
//정상적인 상태
@JsonSerializable()
class UserModel extends UserModelBase{
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.imageUrl,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json)
  => _$UserModelFromJson(json);
}
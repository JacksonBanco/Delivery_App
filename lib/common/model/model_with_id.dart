//모든 모델에 id있으니 일반화 작업

abstract class IModelWithId{
  final String id;

  IModelWithId({
    required this.id,
  });
}
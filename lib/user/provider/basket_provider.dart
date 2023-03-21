import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/basket_item_model.dart';
import 'package:actual/user/model/patch_basket_body.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);

    return BasketProvider(
      repository: repository,
    );
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  //Optimistic Response(긍정적 응답)
  //응답이 성공할거라고 가정하고 상태를 먼저 업데이트함

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                count: e.count,
                productId: e.product.id,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    //지금까지는 요청을 먼저 보내고 응답이 오면 캐시를 업데이트를 했다.

    //1)아직 장바구니에 해당되는 상품이 없다면 장바구니에 상품을 추간한다
    //2)만약에 이미 들어있다면 장바구니에 있는 값에 +1을 한다.
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            //장바구니에서 해당 상품을 찾고 상품의 아디를 찾았다면  카운터 1을 올려라
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                    //찾지못했다면 그냥 그대로 e
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          count: 1,
          product: product,
        ),
      ];
    }
    await patchBasket();
  }

//장바구니에서 상품을 삭제
  Future<void> removeFromBasket({
    required ProductModel product,
    //true면 count와 관계없이 아예 삭제한다
    bool isDelete = false,
  }) async {
    //1) 장바구니에 상품이 존재할때
    // 1-1 상품의 카운터가 1보다 크면 -1
    // 1-2 상품의 카운터가 1이면 삭제한다.
    //2) 장바구니에 상품이 존재하지않을때 즉시 함수를 반환하고 아무것도 하지않는다.
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }
    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map(
            //장바구니에서 해당 상품을 찾고 상품의 아디를 찾았다면  카운터 -1
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count - 1,
                    //찾지못했다면 그냥 그대로 e
                  )
                : e,
          )
          .toList();
    }
    await patchBasket();
  }
}

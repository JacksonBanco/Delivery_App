import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if(state is! CursorPagination){
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {

  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    //만약게 아직 데이터가 하나도 없는 상태라면(CursorPagination이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if(state is! CursorPagination){
      await this.paginate();
    }
    //state가 CursorPagination이 아닐때 그냥 null 리턴 반환
    if(state is! CursorPagination){
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)] 있는 상황에
    // id:2인 모델을 Detail모델을 가져와라라는 요청이 오면
    // getDetail(id: 2); 실행하게 되고
    // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)] 로 바뀜
    state = pState.copyWith(
      data: pState.data.map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
      ).toList(),
    );
  }
}

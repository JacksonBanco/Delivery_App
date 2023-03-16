import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = RestaurantRepository(dio, baseUrl: 'http://$ipAndroid/restaurant');

    return repository;
  });

@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel>{
  //baseurl를 어떻게 넣을꺼냐? http://$ipAndroid/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  //http://$ipAndroid/restaurant
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
});

  //http://$ipAndroid/restaurant/:id
  @GET('/{id}')
  //Future로 받는이유 : api요청이라서 외부에서 요청을 받기때문에
  //매번 헤더에 accessToken를 넣을수없으니  'accessToken' : 'true',으로 지정하고
  // dio Interceptor자동으로 요청보냄
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}

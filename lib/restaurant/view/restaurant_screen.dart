import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();
/*  //api서버로부터 20개를 받아오는 data(list)값을 반환해주슨 함수
  Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final dio = ref.watch(dioProvider);

    // resp에서 가져오는 값은 cursor_pagination 클래스의 인스턴스인데 거기서 data만 가져옴
    final resp = await RestaurantRepository(dio, baseurl: 'http://$ipAndroid/restaurant').paginate();

    //api서버로 부터 받은 데이터중에 다 포함되어 있지만 그중 'data'만 받아오는거임
    return resp.data;
  }*/

  //controller의 어느 특정값이 바뀔때마다 scrollListener함수가 돌아감
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    //현재 위치가 최대 스크롤길이보다 조금 덜 되는 위치까지 왔다면
    //새로운 데이터를 추가요청하는 함수 여기서 hasMore이 true냐 false냐 이거는 provider파일에
    //다 만들어놈
    // 현재 위치 > 최대스크롤한 위치
    if (controller.offset > controller.position.maxScrollExtent) {
      ref.read(restaurantProvider.notifier).paginate(
          fetchMore: true //paginate()에 아무것도 안넣으면 처음부터 로딩 그래서 fetchMore
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    //완전 처음 로딩일때
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    //CursorPagination
    //CursorPaginationFetchMore
    //CursorPagination
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1, //레스토랑의 정보가 들어잇음
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: data is CursorPaginationRefetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 정보입니다'),
              ),
            );
          }
          final pItem = cp.data[index];

          //parsed 변환됐다 한번더 파싱
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: pItem.id,
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(model: pItem),
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(
            height: 16.0,
          );
        },
      ),
    );
  }
}

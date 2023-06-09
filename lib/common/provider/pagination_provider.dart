import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
> extends StateNotifier<CursorPaginationBase> {

  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()){
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    //false - 새로고침(현재 상태를 덮어씌움)
    //true = 추가로 20개 데이터 더 가져오기
    bool fetchMore = false,
    //강제로 다시 로딩하기
    //true = CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try{
      //5가지 케이스 가능성
      //State의 상태
      //1 CursorPagination 정상적으로 데이터가 있는상태
      //2 CursorPaginationLoading -데이터가 로딩중인 상태 (현재 캐시 없음)
      //3 CursorPaginationError - 에러가 있는상태
      //4 CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      //5 CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      //바로 반환하는 상황
      //1 hasMore = false(기존 상태에서 이미 다음 데이터가 없다는값을 들고있다면)
      //2 로딩중 - fetchMore가 true일때
      //2-1   fetchMore가 false일때 그냥 함수 실행 - 새로고침의 의도가 있을수 있다
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }
      //로딩중 3가지 케이스
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isisRefetchingMore = state is CursorPaginationRefetchingMore;

      //2번 로딩중일때 반환 상황
      if (fetchMore && (isLoading || isRefetching || isisRefetchingMore)) {
        return;
      }

      //PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      //fetchMore
      //데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationRefetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }

      //데이터를 처음부터 가져오는 상황
      else {
        //만야게 데이터가 있는상황이라면 기본 데이터를 보존한채로 Fetch(API요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            data: pState.data,
            meta: pState.meta,
          );
          //나머지 상황황
        } else {
          state = CursorPaginationLoading();
        }
      }

      //최신 데이터 20개
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationRefetchingMore) {
        final pState = state as CursorPaginationRefetchingMore<T>;

        //최신 데이터에서 20개 플러스 그러고 또 플러스
        state = resp.copyWith(
          data: [
            ...pState.data, //기존데이터 20개
            ...resp.data, //추가 데이터 20개
          ],
        );
      }else{
        state = resp;
      }
    }catch(e){
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다');
    }
  }
}
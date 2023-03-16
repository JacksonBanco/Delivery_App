import 'package:actual/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';


class PaginationUtils{
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
}){
    if (controller.offset > controller.position.maxScrollExtent -300) {
      provider.paginate(
          fetchMore: true //paginate()에 아무것도 안넣으면 처음부터 로딩 그래서 fetchMore
      );
    }
  }
}
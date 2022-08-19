import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/neox_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:loading_more_list/loading_more_list.dart';

class NeoxRepository extends LoadingMoreBase<BookItem> {
  RxList<BookItem> lista = <BookItem>[].obs;
  // @override
  // bool get hasMore => length < lista.length;

  RxBool isSuccess = false.obs;
  bool forceRefresh = false;

  @override
  bool get hasMore => (length < lista.length) || forceRefresh;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    forceRefresh = !notifyStateChanged;
    var result = await super.refresh(notifyStateChanged);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = true]) async {
    try {
      lista.value = await NeoxServices.lastAdded;
      await Future.delayed(const Duration(milliseconds: 350));
      for (var item in lista) {
        print(item.name);
        if (!contains(item)) {
          add(item);
        }
      }

      isSuccess.value = true;
      return isSuccess.value;
    } catch (e) {
      isSuccess.value = false;
      if (kDebugMode) {
        print(e);
      }
      return isSuccess.value;
    }
  }
}

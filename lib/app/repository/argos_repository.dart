import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ArgosRepository extends LoadingMoreBase<BookItem> {
  // NeoxRepository({
  //   required this.lastAdded,
  // });

  // final Future<List<BookItem>> lastAdded;

  RxList<BookItem> lista = <BookItem>[].obs;

  RxBool isSuccess = false.obs;

  @override
  bool get hasMore => length < lista.length;

  @override
  void dispose() {
    lista.close();
    isSuccess.close();
    super.dispose();
  }

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    try {
      lista.value = await ArgosService.lastAdded;
      for (var item in lista) {
        if (!contains(item)) {
          add(item);
        }
      }
      isSuccess.value = true;
      return super.refresh(isSuccess.value);
    } catch (e) {
      isSuccess.value = false;
      if (kDebugMode) {
        print(e);
      }
      return super.refresh(isSuccess.value);
    }
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    try {
      lista.value = await ArgosService.lastAdded;

      for (var item in lista) {
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

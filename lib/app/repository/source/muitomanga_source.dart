import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/muito_manga_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class MuitoMangaSource extends LoadingMoreBase<BookItem> {
  RxList<BookItem> lista = <BookItem>[].obs;

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
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    try {
      lista.value = await MuitoMangaServices.lastAdded;

      await Future.delayed(const Duration(milliseconds: 350));
      for (var item in lista) {
        if (!contains(item)) {
          add(item);
        }
      }

      isSuccess.value = true;
      return isSuccess.value;
    } catch (exception, stack) {
      isSuccess.value = false;
      if (kDebugMode) {
        print(exception);
        print(stack);
      }
      return isSuccess.value;
    }
  }
}

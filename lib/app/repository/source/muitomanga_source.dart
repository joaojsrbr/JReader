import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/muito_manga_services.dart';
import 'package:flutter/foundation.dart';
import 'package:loading_more_list/loading_more_list.dart';

class MuitoMangaSource extends LoadingMoreBase<BookItem> {
  List<BookItem> lista = <BookItem>[];

  bool isSuccess = false;

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
      lista = await MuitoMangaServices.lastAdded;

      for (var item in lista) {
        if (!contains(item)) {
          add(item);
        }
      }

      isSuccess = true;
      return isSuccess;
    } catch (exception, stack) {
      isSuccess = false;
      if (kDebugMode) {
        print(exception);
        print(stack);
      }
      return isSuccess;
    }
  }
}

import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
import 'package:flutter/foundation.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ArgosSource extends LoadingMoreBase<BookItem> {
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
      lista = await ArgosService.popular;

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

// class ArgosRepositoryL extends LoadingMoreBase<BookItem> {
//   // NeoxRepository({
//   //   required this.lastAdded,
//   // });

//   // final Future<List<BookItem>> lastAdded;

//   RxList<BookItem> lista = <BookItem>[].obs;

//   RxBool isSuccess = false.obs;
//   bool forceRefresh = false;

//   @override
//   bool get hasMore => (length < lista.length) || forceRefresh;

//   @override
//   Future<bool> refresh([bool notifyStateChanged = false]) async {
//     forceRefresh = !notifyStateChanged;
//     var result = await super.refresh(notifyStateChanged);
//     forceRefresh = false;
//     return result;
//   }

//   @override
//   Future<bool> loadData([bool isloadMoreAction = false]) async {
//     try {
//       lista.value = await ArgosService.lastAdded;

//       for (var item in lista) {
//         if (!contains(item)) {
//           add(item);
//         }
//       }

//       isSuccess.value = true;
//       return isSuccess.value;
//     } catch (e) {
//       isSuccess.value = false;
//       if (kDebugMode) {
//         print(e);
//       }
//       return isSuccess.value;
//     }
//   }
// }

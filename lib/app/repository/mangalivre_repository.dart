import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:loading_more_list/loading_more_list.dart';

class MangaLivreRepository extends LoadingMoreBase<BookItem> {
  @override
  Future<bool> loadData([Object isloadMoreAction = false]) {
    throw UnimplementedError();
  }
}

import 'package:A.N.R/app/models/book_item.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

part 'favorites_store.g.dart';

class FavoritesStore = FavoritesStoreBase with _$FavoritesStore;

abstract class FavoritesStoreBase with Store {
  @observable
  ObservableMap<String, BookItem> favorites = ObservableMap();

  @computed
  List<BookItem> get items {
    final List<BookItem> favoritesList = favorites.values.toList();
    favoritesList.sort((a, b) => compareNatural(a.id, b.id));
    return favoritesList;
  }

  @action
  void set(Map<String, BookItem> data) => favorites.addAll(data);

  @action
  void add(BookItem book) {
    favorites.update(book.id, (_) => book, ifAbsent: () => book);
  }

  @action
  void remove(String id) => favorites.remove(id);
}

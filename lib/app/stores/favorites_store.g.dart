// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FavoritesStore on FavoritesStoreBase, Store {
  Computed<List<BookItem>>? _$itemsComputed;

  @override
  List<BookItem> get items =>
      (_$itemsComputed ??= Computed<List<BookItem>>(() => super.items,
              name: 'FavoritesStoreBase.items'))
          .value;

  final _$favoritesAtom = Atom(name: 'FavoritesStoreBase.favorites');

  @override
  ObservableMap<String, BookItem> get favorites {
    _$favoritesAtom.reportRead();
    return super.favorites;
  }

  @override
  set favorites(ObservableMap<String, BookItem> value) {
    _$favoritesAtom.reportWrite(value, super.favorites, () {
      super.favorites = value;
    });
  }

  final _$FavoritesStoreBaseActionController =
      ActionController(name: 'FavoritesStoreBase');

  @override
  void set(Map<String, BookItem> data) {
    final $actionInfo = _$FavoritesStoreBaseActionController.startAction(
        name: 'FavoritesStoreBase.set');
    try {
      return super.set(data);
    } finally {
      _$FavoritesStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  void add(BookItem book) {
    final $actionInfo = _$FavoritesStoreBaseActionController.startAction(
        name: 'FavoritesStoreBase.add');
    try {
      return super.add(book);
    } finally {
      _$FavoritesStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  void remove(String id) {
    final $actionInfo = _$FavoritesStoreBaseActionController.startAction(
        name: 'FavoritesStoreBase.remove');
    try {
      return super.remove(id);
    } finally {
      _$FavoritesStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
favorites: ${favorites},
items: ${items}
    ''';
  }
}

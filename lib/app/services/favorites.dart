import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/manga_host_services.dart';
import 'package:com_joaojsrbr_reader/app/services/search.dart';
import 'package:com_joaojsrbr_reader/app/stores/favorites_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Favorites {
  final BookItem book;
  final FavoritesStore store;
  final BuildContext context;

  const Favorites({
    required this.book,
    required this.store,
    required this.context,
  });

  bool get isFavorite => store.favorites.containsKey(book.id);

  static DatabaseReference? get ref {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final favoritesRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/favorites');

    favoritesRef.keepSynced(true);

    return favoritesRef;
  }

  static Future<void> updateAll(BuildContext context) async {
    if (ref == null) return _snackError(context);

    // final FavoritesStore store = Provider.of<FavoritesStore>(
    //   context,
    //   listen: false,
    // );

    try {
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      for (DataSnapshot element in snapshot.children) {
        final item = element.value as Map<dynamic, dynamic>;
        final String url = item['url'].toString();
        final String name = item['name'].toString();
        final bookItem = await searchByUrl(url, name);

        final String id = item['id'].toString();
        final String imageURL = item['imageURL'].toString();
        final String imageURL2 = item['imageURL2'].toString();
        // final bool isMH = MangaHostServices.isMH(url);
        final DatabaseReference bookRef = ref!.child(id);
        final String tag = item['tag'];
        for (var book in bookItem) {
          if (kDebugMode) {
            print('${book.url} - $url ');
          }
          if (book.id == id) {
            if (url != book.url) {
              bookRef.set(
                BookItem(
                  id: item['id'],
                  url: book.url,
                  tag: tag,
                  name: book.name,
                  imageURL: imageURL,
                  imageURL2: imageURL2,
                  lastChapter: book.lastChapter,
                ).toMap,
              );

              // store.add(
              //   BookItem(
              //     id: item['id'],
              //     url: book.url,
              //     tag: tag,
              //     name: book.name,
              //     imageURL: imageURL,
              //     imageURL2: imageURL2,
              //     lastChapter: book.lastChapter,
              //     headers: isMH ? MangaHostServices.headers(url) : book.headers,
              //   ),
              // );
            }
          }
        }
        // store.favorites
        //     .removeWhere((key, value) => !favorites.containsKey(key));

        // store.favorites.removeWhere((key, value) => !favorites.containsKey(key));
        // store.set(favorites);
      }
    } catch (err) {
      _snackError(context);
    }
  }

  static Future<void> getAll(BuildContext context) async {
    if (ref == null) return _snackError(context);

    final FavoritesStore store = Provider.of<FavoritesStore>(
      context,
      listen: false,
    );

    try {
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      final Map<String, BookItem> favorites = {};

      for (DataSnapshot element in snapshot.children) {
        final item = element.value as Map<dynamic, dynamic>;
        final String url = item['url'].toString();

        final bool isMH = MangaHostServices.isMH(url);

        favorites[element.key!] = BookItem(
          id: item['id'],
          url: url,
          tag: item['tag'],
          name: item['name'],
          imageURL: item['imageURL'],
          imageURL2: item['imageURL2'],
          lastChapter: item['lastChapter'],
          headers: isMH ? MangaHostServices.headers(url) : null,
        );
      }

      store.favorites.removeWhere((key, value) => !favorites.containsKey(key));
      store.set(favorites);
    } catch (err) {
      _snackError(context);
    }
  }

  void toggleFavorite() {
    if (ref == null) return _snackError(context);

    final DatabaseReference bookRef = ref!.child(book.id);

    if (isFavorite) {
      store.remove(book.id);
      bookRef.remove();
    } else {
      store.add(book);
      bookRef.set(book.toMap);
    }
  }

  Widget get button {
    return Observer(builder: (_) {
      return IconButton(
        onPressed: toggleFavorite,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_outline,
          color: isFavorite ? Colors.red : null,
        ),
      );
    });
  }

  static void _snackError(BuildContext context) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Não foi possível sincronizar seus favoritos'),
      ),
    );
  }
}

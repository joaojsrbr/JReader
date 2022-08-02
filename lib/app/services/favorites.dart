import 'package:A.N.R/app/models/book_item.dart';
import 'package:A.N.R/app/services/scans/manga_host_services.dart';
import 'package:A.N.R/app/store/favorites_store.dart';
import 'package:A.N.R/app/widgets/animated_fade_out_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

        final bool isMH = url.contains('mangahosted.com');
        final bool isMHHeader = isMH || url.contains('mangahost4.com');

        favorites[element.key!] = BookItem(
          id: item['id'],
          url: url,
          tag: item['tag'],
          name: item['name'],
          imageURL: item['imageURL'],
          imageURL2: item['imageURL2'],
          headers: isMHHeader ? MangaHostServices.headers : null,
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
    return Observer(
      builder: (_) {
        return AnimatedFadeOutIn<IconData>(
          data: isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          builder: (data) {
            return IconButton(
              onPressed: toggleFavorite,
              icon: Icon(
                data,
                color: isFavorite ? Colors.red : null,
              ),
            );
          },
        );
        // return IconButton(
        //   onPressed: toggleFavorite,
        //   icon: Icon(
        //     isFavorite
        //         ? Icons.favorite_rounded
        //         : Icons.favorite_outline_rounded,
        //     color: isFavorite ? Colors.red : null,
        //   ),
        // );
      },
    );
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

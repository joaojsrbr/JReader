import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class Historic {
  final String bookID;
  final HistoricStore store;
  final BuildContext context;

  const Historic({
    required this.bookID,
    required this.store,
    required this.context,
  });

  static DatabaseReference? get ref {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final historicRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/historic');

    historicRef.keepSynced(true);

    return historicRef;
  }

  static Future<void> getAll(BuildContext context) async {
    if (ref == null) return _snackError(context);

    final HistoricStore store = Provider.of<HistoricStore>(context);

    try {
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      final Map<String, ObservableMap<String, double>> historic = {};

      for (DataSnapshot element in snapshot.children) {
        final Iterable<DataSnapshot> items = element.children;
        final ObservableMap<String, double> chapters = ObservableMap();

        for (DataSnapshot item in items) {
          chapters[item.key!] = double.tryParse(item.value.toString()) ?? 0.0;
        }

        historic[element.key!] = chapters;
      }

      store.historic.removeWhere((key, value) => !historic.containsKey(key));
      store.set(historic);
    } catch (e) {
      // print(e);
      _snackError(context);
    }
  }

  void toggleHistoric(String id, double position) {
    if (ref == null) return _snackError(context);

    final DatabaseReference chapterRef = ref!.child(bookID).child(id);

    store.add(bookID, id, position);
    chapterRef.set(position);
  }

  static void _snackError(BuildContext context) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Não foi possível sincronizar seu histórico de leitura'),
      ),
    );
  }
}

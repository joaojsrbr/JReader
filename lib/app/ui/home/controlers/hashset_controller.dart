import 'dart:collection';

import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class HashSetController extends ValueNotifier<HashSet<String>> {
  HashSetController() : super(HashSet());

  void add(String path) {
    if (value.contains(path)) {
      value.remove(path);
      notifyListeners();
    } else {
      value.add(path);
      notifyListeners();
    }
  }

  Future<void> removedb() async {
    final ref = Favorites.ref;

    if (ref == null) return;
    final DataSnapshot snapshot = await ref.get();
    if (!snapshot.exists) return;

    for (DataSnapshot element in snapshot.children) {
      final item = element.value as Map<dynamic, dynamic>;
      for (var hash in value) {
        if (item.containsValue(hash)) {
          final DatabaseReference bookRef = ref.child(item['id']);
          bookRef.remove();
          value.removeWhere((element) => element == hash);
          notifyListeners();
        }
      }
    }
    // value.clear();
    // notifyListeners();
  }
}

import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:flutter/material.dart';

class ResultsController extends ValueNotifier<List<BookItem>> {
  ResultsController() : super([]);

  void addAll(List<List<BookItem>> data) {
    if (value.isNotEmpty) {
      value.clear();
    }

    for (var book in data) {
      for (BookItem bookItem in book) {
        if (!value.contains(bookItem)) {
          value.add(bookItem);
          notifyListeners();
        }
      }
    }
  }
}

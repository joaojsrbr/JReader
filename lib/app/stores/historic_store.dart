import 'package:mobx/mobx.dart';

part 'historic_store.g.dart';

class HistoricStore = HistoricStoreBase with _$HistoricStore;

abstract class HistoricStoreBase with Store {
  @observable
  ObservableMap<String, ObservableMap<String, double>> historic =
      ObservableMap();

  @action
  void set(Map<String, ObservableMap<String, double>> data) {
    historic.addAll(data);
  }

  @action
  void add(String bookID, String id, double position) {
    ObservableMap<String, double>? book = historic[bookID];

    if (book == null) {
      historic[bookID] = ObservableMap();

      book = historic[bookID];
      book![id] = position;
    } else {
      book.update(id, (_) => position, ifAbsent: () => position);
    }
  }

  @action
  void remove(String bookID, String id) => historic[bookID]?.remove(id);
}

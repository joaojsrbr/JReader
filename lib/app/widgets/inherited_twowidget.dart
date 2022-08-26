import 'package:flutter/material.dart';

typedef Type<T> = ValueNotifier<T>;

class InheritedTwoWidgetValueNotifier<Type>
    extends InheritedNotifierTwo<ValueNotifier<Type>> {
  const InheritedTwoWidgetValueNotifier({
    super.key,
    required ValueNotifier<Type> super.first,
    required ValueNotifier<Type> super.second,
    required super.child,
  });

  @override
  bool updateShouldNotify(InheritedTwoWidgetValueNotifier<Type> oldWidget) {
    return first?.value != oldWidget.first?.value ||
        second?.value != oldWidget.second?.value;
  }

  Type get value1 => first!.value;

  Type get value2 => second!.value;

  static InheritedTwoWidgetValueNotifier<Type> of<Type>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        InheritedTwoWidgetValueNotifier<Type>>()!;
  }
}

abstract class InheritedNotifierTwo<T extends Listenable>
    extends InheritedWidget {
  const InheritedNotifierTwo({
    Key? key,
    this.first,
    this.second,
    required Widget child,
  }) : super(key: key, child: child);

  final T? first;
  final T? second;

  @override
  bool updateShouldNotify(InheritedNotifierTwo<T> oldWidget) {
    return oldWidget.first != first || oldWidget.second != second;
  }

  @override
  InheritedElement createElement() => _InheritedNotifierElement<T>(this);
}

class _InheritedNotifierElement<T extends Listenable> extends InheritedElement {
  _InheritedNotifierElement(InheritedNotifierTwo<T> widget) : super(widget) {
    widget.first?.addListener(_handleUpdate);
    widget.second?.addListener(_handleUpdate);
  }

  bool _dirty = false;

  @override
  void update(InheritedNotifierTwo<T> newWidget) {
    List<T?> oldNotifier = [
      (widget as InheritedNotifierTwo<T>).first,
      (widget as InheritedNotifierTwo<T>).second
    ];

    List<T?> newNotifier = [
      newWidget.first,
      newWidget.second,
    ];

    if (oldNotifier.first != newNotifier.first) {
      oldNotifier.first?.removeListener(_handleUpdate);
      newNotifier.first?.addListener(_handleUpdate);
    } else if (oldNotifier.last != newNotifier.last) {
      oldNotifier.last?.removeListener(_handleUpdate);
      newNotifier.last?.addListener(_handleUpdate);
    }

    // for (var element in IterableZip([oldNotifier, newNotifier])) {
    //     if (element[0] != element[1]) {
    //       element[0]?.removeListener(_handleUpdate);
    //       element[1]?.addListener(_handleUpdate);
    //     } else if (oldNotifier.last != newNotifier.last) {
    //       oldNotifier.last?.removeListener(_handleUpdate);
    //       newNotifier.last?.addListener(_handleUpdate);
    //     }
    //   }

    // for (var i in oldNotifier) {
    //   for (var e in newNotifier) {
    //     if (i != e) {
    //       i?.removeListener(_handleUpdate);
    //       e?.addListener(_handleUpdate);
    //     }
    //   }
    // }

    // final T? oldNotifier1 = (widget as InheritedNotifierTwo<T>).first;
    // final T? newNotifier1 = newWidget.first;
    // final T? oldNotifier2 = (widget as InheritedNotifierTwo<T>).second;
    // final T? newNotifier2 = newWidget.second;
    // if (oldNotifier1 != newNotifier1) {
    //   oldNotifier1?.removeListener(_handleUpdate);
    //   newNotifier1?.addListener(_handleUpdate);
    // } else if (oldNotifier2 != newNotifier2) {
    //   oldNotifier2?.removeListener(_handleUpdate);
    //   newNotifier2?.addListener(_handleUpdate);
    // }
    super.update(newWidget);
  }

  @override
  Widget build() {
    if (_dirty) notifyClients(widget as InheritedNotifierTwo<T>);
    return super.build();
  }

  void _handleUpdate() {
    _dirty = true;
    markNeedsBuild();
  }

  @override
  void notifyClients(InheritedNotifierTwo<T> oldWidget) {
    super.notifyClients(oldWidget);
    _dirty = false;
  }

  @override
  void unmount() {
    (widget as InheritedNotifierTwo<T>).first?.removeListener(_handleUpdate);
    (widget as InheritedNotifierTwo<T>).second?.removeListener(_handleUpdate);
    super.unmount();
  }
}

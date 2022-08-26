import 'package:flutter/material.dart';

typedef Type<T> = ValueNotifier<T>;

class InheritedWidgetValueNotifier<Type>
    extends InheritedNotifier<ValueNotifier<Type>> {
  const InheritedWidgetValueNotifier({
    super.key,
    required ValueNotifier<Type> super.notifier,
    required super.child,
  });

  @override
  bool updateShouldNotify(oldWidget) {
    return notifier?.value != oldWidget.notifier?.value;
  }

  Type get value => notifier!.value;

  static InheritedWidgetValueNotifier of<Type>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        InheritedWidgetValueNotifier<Type>>()!;
  }
}

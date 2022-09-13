import 'package:flutter/material.dart';

typedef Book<T> = List<T>;

class SliverGridBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext context, int index, T data) builder;
  final SliverGridDelegate gridDelegate;
  final Book<T> lista;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Key)? findChildIndexCallback;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  const SliverGridBuilder({
    super.key,
    required this.builder,
    required this.gridDelegate,
    required this.lista,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  });

  static int _kDefaultSemanticIndexCallback(Widget _, int localIndex) =>
      localIndex;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => builder(context, index, lista[index]),
        findChildIndexCallback: findChildIndexCallback,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        semanticIndexOffset: semanticIndexOffset,
        childCount: lista.length,
      ),
      gridDelegate: gridDelegate,
    );
  }
}

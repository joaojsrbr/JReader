import 'package:flutter/material.dart';

class BookElementSliverGrid extends StatelessWidget {
  final SliverChildBuilderDelegate delegate;

  const BookElementSliverGrid({required this.delegate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      sliver: SliverGrid(
        delegate: delegate,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.72,
          maxCrossAxisExtent: 156,
        ),
      ),
    );
  }
}

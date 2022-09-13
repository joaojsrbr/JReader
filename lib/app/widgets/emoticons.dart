import 'dart:math';

import 'package:flutter/material.dart';

const errorFaces = [
  '(･o･;)',
  'Σ(ಠ_ಠ)',
  'ಥ_ಥ',
  '(˘･_･˘)',
  '(；￣Д￣)',
  '(･Д･。',
];

class EmoticonsView extends StatelessWidget {
  const EmoticonsView({
    super.key,
    required this.text,
    this.button,
  });
  final String text;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Text(
            errorFaces[random.nextInt(6)],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          subtitle: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        button ?? const SizedBox.shrink()
      ],
    );
  }
}

import 'package:com_joaojsrbr_reader/app/core/constants/iconsax_icons.dart';
import 'package:custom_selectable_text/custom_selectable_text.dart';
import 'package:flutter/material.dart';

class SelectTitle extends StatelessWidget {
  const SelectTitle({super.key, required this.data, this.end, this.style});

  final String data;
  final bool? end;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return CustomSelectableText(
      data,
      minLines: 1,
      style: style,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      maxLines: end ?? true ? 2 : 5,
      items: [
        CustomSelectableTextItem.icon(
          icon: const Icon(Iconsax.copy),
          controlType: SelectionControlType.copy,
          onPressed: (value) {
            final message = ScaffoldMessenger.of(context);
            message.clearSnackBars();
            message.showSnackBar(
              const SnackBar(
                content: Text(
                  "Copiado para a área de transferência",
                ),
              ),
            );
          },
        ),
        CustomSelectableTextItem.icon(
          icon: const Icon(Icons.select_all_rounded),
          controlType: SelectionControlType.selectAll,
        ),
      ],
    );
  }
}

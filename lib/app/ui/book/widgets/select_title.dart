import 'package:com_joaojsrbr_reader/app/core/constants/iconsax_icons.dart';
import 'package:custom_selectable_text/custom_selectable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTitle extends StatelessWidget {
  SelectTitle({super.key, required this.data, this.style});

  final String data;
  final FocusNode focusNode = FocusNode();

  final TextStyle? style;

  void onPressed(BuildContext context) async {
    final message = ScaffoldMessenger.of(context);
    message.clearSnackBars();
    await 0.3.delay(
      () => message.showSnackBar(
        const SnackBar(
          content: Text(
            "Título copiado para a área de ransferência",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomSelectableText(
      data,
      focusNode: focusNode,
      minLines: 1,
      maxLines: 3,
      style: style,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      items: [
        CustomSelectableTextItem.icon(
          icon: const Icon(Iconsax.copy),
          controlType: SelectionControlType.copy,
          onPressed: (value) => onPressed(context),
        ),
        CustomSelectableTextItem.icon(
          icon: const Icon(Icons.select_all_rounded),
          controlType: SelectionControlType.selectAll,
        ),
      ],
    );
  }
}

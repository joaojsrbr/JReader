// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';

// class MyTextSelectionToolbar extends StatelessWidget {
//   const MyTextSelectionToolbar({
//     Key? key,
//     required this.anchorAbove,
//     required this.anchorBelow,
//     required this.clipboardStatus,
//     required this.handleCustomButton,
//   }) : super(key: key);

//   final Offset anchorAbove;
//   final Offset anchorBelow;
//   final ClipboardStatusNotifier clipboardStatus;
//   final VoidCallback? handleCustomButton;

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasMaterialLocalizations(context));

//     final List<_TextSelectionToolbarItemData> items =
//         <_TextSelectionToolbarItemData>[
//       _TextSelectionToolbarItemData(
//         onPressed: handleCustomButton ?? () {},
//         label: 'Custom button',
//       ),
//     ];

//     int childIndex = 0;
//     return TextSelectionToolbar(
//       anchorAbove: anchorAbove,
//       anchorBelow: anchorBelow,
//       toolbarBuilder: (BuildContext context, Widget child) =>
//           Container(color: Colors.pink, child: child),
//       children: items
//           .map((_TextSelectionToolbarItemData itemData) =>
//               TextSelectionToolbarTextButton(
//                 padding: TextSelectionToolbarTextButton.getPadding(
//                     childIndex++, items.length),
//                 onPressed: itemData.onPressed,
//                 child: Text(itemData.label),
//               ))
//           .toList(),
//     );
//   }
// }

// class _TextSelectionToolbarItemData {
//   const _TextSelectionToolbarItemData({
//     required this.label,
//     required this.onPressed,
//   });

//   final String label;
//   final VoidCallback onPressed;
// }

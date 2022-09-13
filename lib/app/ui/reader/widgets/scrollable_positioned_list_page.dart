// // ignore_for_file: sort_child_properties_last

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:com_joaojsrbr_reader/app/widgets/state_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// const minItemHeight = 20.0;
// const maxItemHeight = 150.0;
// const randomMax = 1 << 32;
// const scrollDuration = Duration(seconds: 2);

// class ScrollablePositionedListPage extends StatefulWidget {
//   const ScrollablePositionedListPage({
//     super.key,
//     required this.itemCount,
//     required this.title,
//     required this.imgs,
//     this.httpHeaders,
//   });
//   final int itemCount;
//   final List<String> imgs;
//   final String title;
//   final Map<String, String>? httpHeaders;

//   @override
//   // ignore: library_private_types_in_public_api
//   _ScrollablePositionedListPageState createState() =>
//       _ScrollablePositionedListPageState();
// }

// class _ScrollablePositionedListPageState
//     extends State<ScrollablePositionedListPage> {
//   /// Controller to scroll or jump to a particular item.
//   final ItemScrollController itemScrollController = ItemScrollController();

//   /// Listener that reports the position of items when the list is scrolled.
//   final ItemPositionsListener itemPositionsListener =
//       ItemPositionsListener.create();

//   bool reversed = false;

//   /// The alignment to be used next time the user scrolls or jumps to an item.
//   double alignment = 0;
//   ValueNotifier<bool> appShow = ValueNotifier(true);

//   @override
//   void initState() {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [
//         SystemUiOverlay.top,
//         SystemUiOverlay.bottom,
//       ],
//     );

//     super.initState();
//   }

//   @override
//   void didChangeDependencies() async {
//     await 1.5.delay(() => appShow.value = false);
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => Material(
//         child: OrientationBuilder(
//           builder: (context, orientation) => Column(
//             children: <Widget>[
//               Expanded(
//                 child: Stack(
//                   children: [
//                     InteractiveViewer(
//                       child: list(orientation),
//                     ),
//                     StateChange<bool>(
//                       notifier: appShow,
//                       builder: (context, value) => AnimatedContainer(
//                         duration: const Duration(milliseconds: 350),
//                         height: value ? 50 : 0.0,
//                         curve: Curves.easeInOutCubic,
//                         decoration: BoxDecoration(
//                           color: value
//                               ? Get.theme.colorScheme.background
//                                   .withOpacity(0.44)
//                               : Colors.transparent,
//                         ),
//                         alignment: Alignment.center,
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: const BackButtonIcon(),
//                               color: Colors.white,
//                               tooltip: MaterialLocalizations.of(context)
//                                   .backButtonTooltip,
//                               onPressed: () {
//                                 Navigator.maybePop(context);
//                               },
//                             ),
//                             Text(
//                               widget.title,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // positionsView,
//               // Row(
//               //   children: <Widget>[
//               //     Column(
//               //       children: <Widget>[
//               //         scrollControlButtons,
//               //         const SizedBox(height: 10),
//               //         alignmentControl,
//               //       ],
//               //     ),
//               //   ],
//               // )
//             ],
//           ),
//         ),
//       );

//   Widget list(Orientation orientation) => GestureDetector(
//         onTap: () {
//           appShow.value = !appShow.value;
//         },
//         child: Scrollbar(
//           child: ScrollablePositionedList.builder(
//             itemCount: widget.itemCount,
//             minCacheExtent: 2000,
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             itemBuilder: (context, index) => item(index, orientation),
//             itemScrollController: itemScrollController,
//             itemPositionsListener: itemPositionsListener,
//             reverse: reversed,
//             scrollDirection: Axis.vertical,
//           ),
//         ),
//       );

//   Widget get positionsView => ValueListenableBuilder<Iterable<ItemPosition>>(
//         valueListenable: itemPositionsListener.itemPositions,
//         builder: (context, positions, child) {
//           int? min;
//           int? max;
//           if (positions.isNotEmpty) {
//             // Determine the first visible item by finding the item with the
//             // smallest trailing edge that is greater than 0.  i.e. the first
//             // item whose trailing edge in visible in the viewport.
//             min = positions
//                 .where((ItemPosition position) => position.itemTrailingEdge > 0)
//                 .reduce((ItemPosition min, ItemPosition position) =>
//                     position.itemTrailingEdge < min.itemTrailingEdge
//                         ? position
//                         : min)
//                 .index;
//             // Determine the last visible item by finding the item with the
//             // greatest leading edge that is less than 1.  i.e. the last
//             // item whose leading edge in visible in the viewport.
//             max = positions
//                 .where((ItemPosition position) => position.itemLeadingEdge < 1)
//                 .reduce((ItemPosition max, ItemPosition position) =>
//                     position.itemLeadingEdge > max.itemLeadingEdge
//                         ? position
//                         : max)
//                 .index;
//           }
//           return Row(
//             children: <Widget>[
//               Expanded(child: Text('First Item: ${min ?? ''}')),
//               Expanded(child: Text('Last Item: ${max ?? ''}')),
//             ],
//           );
//         },
//       );

//   Widget get scrollControlButtons => Row(
//         children: <Widget>[
//           const Text('scroll to'),
//           scrollButton(0),
//           scrollButton(5),
//           scrollButton(10),
//           scrollButton(100),
//           scrollButton(1000),
//           scrollButton(5000),
//         ],
//       );

//   final _scrollButtonStyle = ButtonStyle(
//     padding: MaterialStateProperty.all(
//       const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//     ),
//     minimumSize: MaterialStateProperty.all(Size.zero),
//     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//   );

//   Widget scrollButton(int value) => TextButton(
//         key: ValueKey<String>('Scroll$value'),
//         onPressed: () => scrollTo(value),
//         child: Text('$value'),
//         style: _scrollButtonStyle,
//       );

//   Widget jumpButton(int value) => TextButton(
//         key: ValueKey<String>('Jump$value'),
//         onPressed: () => jumpTo(value),
//         child: Text('$value'),
//         style: _scrollButtonStyle,
//       );

//   void scrollTo(int index) => itemScrollController.scrollTo(
//       index: index,
//       duration: scrollDuration,
//       curve: Curves.easeInOutCubic,
//       alignment: alignment);

//   void jumpTo(int index) =>
//       itemScrollController.jumpTo(index: index, alignment: alignment);

//   /// Generate item number [i].
//   Widget item(int i, Orientation orientation) {
//     return ImageLoader(
//       headers: widget.httpHeaders,
//       url: widget.imgs[i],
//       cachekey: i,
//       builder: (context, image) {
//         return image;
//       },
//     );
//   }
// }

// class ImageLoader extends StatefulWidget {
//   final Map<String, String>? headers;
//   final String url;

//   final int cachekey;
//   final Widget Function(BuildContext context, Image image) builder;
//   const ImageLoader({
//     Key? key,
//     required this.builder,
//     required this.url,
//     required this.cachekey,
//     this.headers,
//   }) : super(key: key);

//   @override
//   State<ImageLoader> createState() => _ImageLoaderState();
// }

// class _ImageLoaderState extends State<ImageLoader> {
//   // ignore: non_constant_identifier_names
//   Image _ImageLoader() {
//     Image image = Image(
//       key: ObjectKey(widget.url),
//       loadingBuilder: (BuildContext context, Widget child,
//           ImageChunkEvent? loadingProgress) {
//         if (loadingProgress == null) return child;
//         return SizedBox(
//           height: context.height,
//           // width: 1080,
//           child: Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                       loadingProgress.expectedTotalBytes!
//                   : null,
//             ),
//           ),
//         );
//       },
//       fit: BoxFit.fitWidth,
//       image: CachedNetworkImageProvider(
//         widget.url,
//         headers: widget.headers,
//       ),
//     );
//     return image;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(context, _ImageLoader());
//   }
// }

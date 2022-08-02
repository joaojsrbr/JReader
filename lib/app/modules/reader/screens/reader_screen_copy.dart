// // ignore_for_file: prefer_final_fields

// import 'dart:convert';
// import 'dart:io';

// import 'package:A.N.R/app/core/themes/colors.dart';
// import 'package:A.N.R/app/core/utils/html_template.dart';
// import 'package:A.N.R/app/core/utils/reader_js.dart';
// import 'package:A.N.R/app/models/book_item.dart';
// import 'package:A.N.R/app/models/chapter.dart';
// import 'package:A.N.R/app/modules/reader/controlers/reader_controller.dart';
// import 'package:A.N.R/app/services/book_content.dart';
// import 'package:A.N.R/app/services/historic.dart';
// import 'package:A.N.R/app/store/historic_store.dart';
// import 'package:A.N.R/app/core/utils/books_path.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vector_math/vector_math_64.dart';
// import 'package:provider/provider.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class ReaderScreenTwo extends StatefulWidget {
//   const ReaderScreenTwo({Key? key}) : super(key: key);

//   @override
//   State<ReaderScreenTwo> createState() => _ReaderScreenState();
// }

// class _ReaderScreenState extends State<ReaderScreenTwo>
//     with WidgetsBindingObserver {
//   RxInt _index = 0.obs;
//   late BookItem _book;
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener =
//       ItemPositionsListener.create();
//   late List<Chapter> _chapters;
//   final ReaderController controller = Get.find<ReaderController>();
//   late Historic _historic;
//   @override
//   void initState() {
//     // if (Platform.isAndroid) WebView.platform = AndroidWebView();
//     // itemScrollController = ItemScrollController();
//     super.initState();
//   }

//   RxBool _finished = false.obs;
//   bool _isLoading = true;
//   RxBool _getNextCap = true.obs;

//   String? _position;
//   double? _initPosition;

//   void _toggleHistoric(String? value) {
//     if (value == null) return;

//     // final List<String> values = value!.split(',,');
//     // final int index = _index;
//     // final double position = double.parse(values.last);
//     final double position = double.parse(value);

//     _historic.toggleHistoric(_chapters[_index.value].id, position);
//   }

//   RxList<String> contents = <String>[].obs;

//   Future<void> _getContent() async {
//     final Chapter chapter = _chapters[_index.value];

//     List<String> content = await BooksPath.getContent(_book.id, chapter.id);
//     if (content.isEmpty) content = await bookContent(chapter.url);
//     contents.value = content;
//     // await _js!.insertContent(content, _index, chapter.name);
//     _currentchapters.value = int.parse(_chapters[_index.value].id);
//     // print(_chapters[_index].id);

//     // print(_currentchapters.value += 1);

//     _finished.value = _index.value == int.parse(_chapters.first.id);

//     _getNextCap.value = false;
//     // if (_finished.value) await _js!.finishedChapters();
//   }

//   Future<void> _onLoad() async {
//     if (!_isLoading) return;
//     _isLoading = false;

//     if (_initPosition != null) {
//       final bool continueByHistoric = await _continueByHistoric();

//       if (continueByHistoric) {
//         await itemScrollController.scrollTo(
//           index: _initPosition!.toInt(),
//           duration: const Duration(milliseconds: 600),
//         );
//       }
//     }

//     // await _js!.removeLoading();
//   }

//   void _onNext() async {
//     if (_finished.value || _getNextCap.value) return;
//     _toggleHistoric(_position);
//     // _index = _currentchapters.value + 1;
//     await itemScrollController.scrollTo(
//       index: 0,
//       duration: const Duration(microseconds: 450),
//     );
//     // await Future.delayed(const Duration(milliseconds: 240));
//     _index.value = _index.value - 1;
//     _getContent();
//   }

//   // void _onFinished() {
//   //   _toggleHistoric(_position);
//   // }

//   void _onPosition(message) => _position = message;

//   @override
//   void didChangeDependencies() async {
//     final HistoricStore store = Provider.of<HistoricStore>(context);
//     final args = ModalRoute.of(context)!.settings.arguments as ReaderArguments;

//     _book = args.book;
//     _index.value = args.index;
//     _chapters = args.chapters;
//     _historic = Historic(bookID: _book.id, context: context, store: store);
//     _initPosition = args.position;

//     super.didChangeDependencies();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         break;
//       case AppLifecycleState.inactive:
//         _toggleHistoric(controller.currentIndex.string);
//         break;
//       case AppLifecycleState.paused:
//         break;
//       case AppLifecycleState.detached:
//         _toggleHistoric(controller.currentIndex.string);
//         break;
//     }

//     super.didChangeAppLifecycleState(state);
//   }

//   RxDouble itemTrailingEdge = 1.5.obs;

//   @override
//   void dispose() {
//     _toggleHistoric(_position);
//     // itemScrollController.;
//     super.dispose();
//   }

//   RxInt _currentchapters = 0.obs;

//   void initListeners() async {
//     await Future.delayed(const Duration(milliseconds: 250));
//     await _getContent();
//     await _onLoad();

//     itemPositionsListener.itemPositions.addListener(() async {
//       var positions = itemPositionsListener.itemPositions.value.toList();

//       // var positions = itemPositionsListener.itemPositions.value.toList();
//       // _onPosition(itemPositionsListener.itemPositions.value.toString());
//       controller.currentIndex.value = positions
//           .where((ItemPosition position) => position.itemTrailingEdge > 0)
//           .reduce((ItemPosition min, ItemPosition position) =>
//               position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
//           .index;

//       // print(_chapters[_index].id);
//       // print(controller.currentIndex.value);
//       _onPosition(controller.currentIndex.string);
//       // print(controller.currentIndex.value == contents.length);
//       // print(controller.currentIndex.value == contents.length - 2);
//       // print(itemPositionsListener.itemPositions.value.first.itemLeadingEdge);
//       // print(itemPositionsListener.itemPositions.value.first.itemTrailingEdge);
//       if (controller.currentIndex.value + 2 == contents.length) {
//         // _onFinished(controller.currentIndex.string);
//         // await Future.delayed(Duration(microseconds: 350));
//         if (itemPositionsListener.itemPositions.value.first.itemTrailingEdge <
//             0.7) {
//           itemTrailingEdge.value =
//               itemPositionsListener.itemPositions.value.first.itemTrailingEdge;

//           try {
//             _onNext();
//           } catch (e) {
//             print(e);
//           }
//         }

//         // _toggleHistoric(
//         //     itemPositionsListener.itemPositions.value.first.index.toString());
//         // _onNext();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     initListeners();

//     return Scaffold(
//       body: SafeArea(
//         child: Obx(
//           () => contents.isEmpty
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Stack(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Obx(
//                           () => !(controller.currentIndex.value <= 1)
//                               ? Container()
//                               : AnimatedContainer(
//                                   duration: const Duration(milliseconds: 500),
//                                   alignment: Alignment.center,
//                                   height: 50,
//                                   curve: Curves.linear,
//                                   child: Text(
//                                     'Capítulo: ${_chapters[_index.value].id}',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headline5!
//                                         .copyWith(fontSize: 16),
//                                   ),
//                                 ),
//                         ),
//                         Flexible(
//                           child: Obx(
//                             () => ScrollablePositionedList.builder(
//                               itemCount: contents.length,
//                               itemPositionsListener: itemPositionsListener,
//                               itemScrollController: itemScrollController,
//                               scrollDirection: Axis.vertical,
//                               itemBuilder: (context, index) {
//                                 return CachedNetworkImage(
//                                   imageUrl: contents[index],
//                                   fit: BoxFit.fitWidth,
//                                   filterQuality: FilterQuality.high,
//                                   progressIndicatorBuilder:
//                                       (context, url, downloadProgress) =>
//                                           SizedBox(
//                                     height: context.height,
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                         value: downloadProgress.progress,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         Obx(
//                           () => (!(itemTrailingEdge.value < 1))
//                               ? Container()
//                               : AnimatedContainer(
//                                   duration: const Duration(milliseconds: 500),
//                                   alignment: Alignment.center,
//                                   height: 45,
//                                   child: const Text(
//                                     'Não há mais capítulos no memento.',
//                                   ),
//                                 ),
//                         ),
//                       ],
//                     ),
//                     // WebView(
//                     //   initialUrl: _html,
//                     //   javascriptMode: JavascriptMode.unrestricted,
//                     //   backgroundColor: CustomColors.background,
//                     //   gestureNavigationEnabled: true,
//                     //   onWebViewCreated: (controller) {
//                     //     _js = ReaderJS(controller);
//                     //   },
//                     //   onPageFinished: (_) => _getContent(),
//                     //   javascriptChannels: {
//                     //     JavascriptChannel(name: 'onLoad', onMessageReceived: _onLoad),
//                     //     JavascriptChannel(name: 'onNext', onMessageReceived: _onNext),
//                     //     JavascriptChannel(
//                     //         name: 'onFinished', onMessageReceived: _onFinished),
//                     //     JavascriptChannel(
//                     //         name: 'onPosition', onMessageReceived: _onPosition),
//                     //   },
//                     // ),
//                     const SizedBox(
//                       height: 50,
//                       width: 50,
//                       child: BackButton(),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Future<bool> _continueByHistoric() async {
//     final bool? continueByHistoric = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Theme.of(context).colorScheme.background,
//           title: const Text('Continuar de onde parou'),
//           content: Text(
//             'Você já começou a ler esse livro, desejá continuar a leitura de onde parou?',
//             style: Theme.of(context).textTheme.headline6!.copyWith(
//                   fontSize: 14,
//                 ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('NÃO'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('SIM'),
//             ),
//           ],
//         );
//       },
//     );

//     return continueByHistoric ?? false;
//   }
// }

// class ReaderArguments {
//   final int index;
//   final BookItem book;
//   final List<Chapter> chapters;
//   final double? position;

//   const ReaderArguments({
//     required this.index,
//     required this.book,
//     required this.chapters,
//     this.position,
//   });
// }

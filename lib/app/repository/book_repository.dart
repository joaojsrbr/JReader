// import 'package:A.N.R/app/models/book_item.dart';
// import 'package:A.N.R/app/services/scans/argos_services.dart';
// import 'package:A.N.R/app/services/scans/cronos_services.dart';
// import 'package:A.N.R/app/services/scans/manga_host_services.dart';
// import 'package:A.N.R/app/services/scans/mark_services.dart';
// import 'package:A.N.R/app/services/scans/neox_services.dart';
// import 'package:A.N.R/app/services/scans/prisma_services.dart';
// import 'package:A.N.R/app/services/scans/random_services.dart';
// import 'package:A.N.R/app/services/scans/reaper_services.dart';
// import 'package:flutter/foundation.dart';
// // import 'package:get/get.dart';
// import 'package:loading_more_list/loading_more_list.dart';

// class ItemBookRepository extends LoadingMoreBase<BookItem> {
//   ItemBookRepository({
//     required this.index,
//   });

//   final int index;

//   bool isSuccess = false;

//   List<BookItem> lista = [];

//   int listalength = 0;

//   // bool _returnbool(int length) {
//   //   if (length < listalength) {
//   //     return false;
//   //   } else if (length < listalength) {
//   //     return false;
//   //   } else if (length < listalength) {
//   //     return false;
//   //   } else if (length < listalength || length < listalength) {
//   //     return false;
//   //   }
//   //   return true;
//   // }

//   @override
//   bool get hasMore => length < listalength;

//   // @override
//   // bool get hasMore => super.hasMore;

//   // @override
//   // void setState() {
//   //   index;
//   //   refresh(true);
//   //   super.setState();
//   // }

//   @override
//   Future<bool> refresh([bool notifyStateChanged = false]) async {
//     try {
//       lista = [];
//       switch (index) {
//         case 0:
//           lista = await NeoxServices.lastAdded;
//           if (lista.isEmpty) lista = [];

//           break;
//         case 1:
//           lista = await MarkServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await MarkServices.lastAdded);
//           break;
//         case 2:
//           lista = await RandomServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await RandomServices.lastAdded);
//           break;
//         case 3:
//           lista = await CronosServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await CronosServices.lastAdded);
//           break;
//         case 4:
//           lista = await PrismaServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await PrismaServices.lastAdded);
//           break;
//         case 5:
//           lista = await ReaperServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await ReaperServices.lastAdded);
//           break;
//         case 6:
//           lista = await MangaHostServices.lastAdded;

//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await MangaHostServices.lastAdded);
//           break;
//         case 7:
//           lista = await ArgosService.lastAdded;

//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await ArgosService.lastAdded);
//           break;
//       }

//       isSuccess = true;
//       addAll(lista);
//       listalength = lista.length;
//       // if (kDebugMode) {
//       //   print(lista.length);
//       // }
//       return super.refresh(isSuccess);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       isSuccess = false;
//       return super.refresh(isSuccess);
//     }
//   }

//   @override
//   Future<bool> loadData([bool isloadMoreAction = false]) async {
//     try {
//       lista = [];
//       switch (index) {
//         case 0:
//           lista = await NeoxServices.lastAdded;

//           if (lista.isEmpty) lista = [];

//           break;
//         case 1:
//           lista = await MarkServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await MarkServices.lastAdded);
//           break;
//         case 2:
//           lista = await RandomServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await RandomServices.lastAdded);
//           break;
//         case 3:
//           lista = await CronosServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await CronosServices.lastAdded);
//           break;
//         case 4:
//           lista = await PrismaServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await PrismaServices.lastAdded);
//           break;
//         case 5:
//           lista = await ReaperServices.lastAdded;
//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await ReaperServices.lastAdded);
//           break;
//         case 6:
//           lista = await MangaHostServices.lastAdded;

//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await MangaHostServices.lastAdded);
//           break;
//         case 7:
//           lista = await ArgosService.lastAdded;

//           if (lista.isEmpty) lista = [];
//           // lista.addAll(await ArgosService.lastAdded);
//           break;
//       }

//       isSuccess = true;
//       addAll(lista);
//       listalength = lista.length;
//       // if (kDebugMode) {
//       //   print(lista.length);
//       // }
//       return isSuccess;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       isSuccess = false;
//       return isSuccess;
//     }
//   }
// }

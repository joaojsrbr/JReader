// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomNamedPageTransition extends PageRouteBuilder {
//   CustomNamedPageTransition(
//     GlobalKey materialAppKey,
//     String routeName, {
//     Object? arguments,
//   }) : super(
//           settings: RouteSettings(
//             arguments: arguments,
//             name: routeName,
//           ),
//           pageBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//           ) {
//             assert(materialAppKey.currentWidget != null);
//             assert(materialAppKey.currentWidget is GetMaterialApp);
//             var mtapp = materialAppKey.currentWidget as GetMaterialApp;
//             var routes = mtapp.routes;
//             print(mtapp.p;
//             assert(routes!.containsKey(routeName));
//             return routes![routeName]!(context);
//           },
//           transitionsBuilder: (
//             BuildContext context,
//             Animation<double> animation,
//             Animation<double> secondaryAnimation,
//             Widget child,
//           ) =>
//               FadeTransition(
//             opacity: animation,
//             child: child,
//           ),
//           transitionDuration: const Duration(seconds: 1),
//         );
// }

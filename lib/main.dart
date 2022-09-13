import 'dart:isolate';
import 'dart:ui';

import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/my_app.dart';
import 'package:com_joaojsrbr_reader/services.dart';
import 'package:flutter/material.dart';

SendPort? send() => IsolateNameServer.lookupPortByName(Ports.DOWNLOAD);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  // runApp(SplashScreen());
  // await Future.delayed(const Duration(seconds: 3));
  runApp(const MyApp());
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 22, 23, 40),
//         body: Center(
//           child: Image.asset(
//             'assets/images/logonobg.png',
//             height: 512,
//             width: 512,
//           ),
//         ),
//       ),
//     );
//   }
// }

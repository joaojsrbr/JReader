import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dilog extends StatelessWidget {
  const Dilog({super.key, required this.awesomeNotifications});
  final AwesomeNotifications awesomeNotifications;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Get.theme.colorScheme.background,
      title: const Text(
        'Nosso aplicativo gostaria de enviar notificações',
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/animated-bell.gif',
            colorBlendMode: BlendMode.color,
            color: Colors.transparent,
            fit: BoxFit.fitWidth,
            height: Get.height * 0.3,
          )
        ],
      ),
      // actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Negar',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => AwesomeNotifications()
              .requestPermissionToSendNotifications()
              .then(
                (_) => Get.back(),
              ),
          child: const Text(
            'Permitir',
            style: TextStyle(
              // color: Colors.teal,
              color: Colors.deepPurple,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

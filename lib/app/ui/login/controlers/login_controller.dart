import 'package:com_joaojsrbr_reader/app/services/session.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late Session session;

  @override
  void onInit() {
    session = Session();
    super.onInit();
  }
}

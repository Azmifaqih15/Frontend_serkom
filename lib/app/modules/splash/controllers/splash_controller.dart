import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  void navigateToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}

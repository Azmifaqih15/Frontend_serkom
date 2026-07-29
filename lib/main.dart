import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/api_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ApiService(), permanent: true);
  Get.put(AuthService(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

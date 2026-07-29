import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isLoading = false.obs;

  final _authService = Get.find<AuthService>();

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEE2E2),
        colorText: const Color(0xFF991B1B),
        icon: const Icon(Icons.error_outline_rounded, color: Color(0xFF991B1B)),
      );
      return;
    }

    isLoading.value = true;

    try {
      final res = await _authService.login(email, password);
      isLoading.value = false;

      if (res['success'] == true) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Gagal Masuk',
          res['message'] ?? 'Email atau password salah. Pastikan akun sudah terdaftar.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFEE2E2),
          colorText: const Color(0xFF991B1B),
          icon: const Icon(Icons.error_outline_rounded, color: Color(0xFF991B1B)),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error Koneksi',
        'Gagal menghubungkan ke server.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEE2E2),
        colorText: const Color(0xFF991B1B),
        icon: const Icon(Icons.error_outline_rounded, color: Color(0xFF991B1B)),
      );
    }
  }

  void loginAsGuest() {
    _authService.loginAsGuest();
    Get.offAllNamed(Routes.HOME);
  }

  void loginWithGoogle() {
    Get.snackbar(
      'Google Login',
      'Fitur login Google akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.container,
      colorText: AppColors.textPrimary,
    );
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

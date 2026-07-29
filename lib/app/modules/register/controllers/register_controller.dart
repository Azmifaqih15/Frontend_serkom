import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  final _authService = Get.find<AuthService>();

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validation
    if (name.isEmpty) {
      showErrorSnackbar('Nama Lengkap tidak boleh kosong');
      return;
    }

    if (email.isEmpty) {
      showErrorSnackbar('Email tidak boleh kosong');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      showErrorSnackbar('Format email tidak valid');
      return;
    }

    if (password.isEmpty) {
      showErrorSnackbar('Password tidak boleh kosong');
      return;
    }

    if (password.length < 6) {
      showErrorSnackbar('Password minimal harus 6 karakter');
      return;
    }

    if (password != confirmPassword) {
      showErrorSnackbar('Konfirmasi password tidak cocok');
      return;
    }

    isLoading.value = true;

    try {
      final res = await _authService.register(name, email, password);
      isLoading.value = false;

      if (res['success'] == true) {
        Get.snackbar(
          'Registrasi Sukses',
          'Akun Anda berhasil didaftarkan! Silakan masuk.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD1FAE5),
          colorText: const Color(0xFF065F46),
          icon: const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF065F46),
          ),
          duration: const Duration(seconds: 3),
        );
        // Back to login screen
        Get.back();
      } else {
        showErrorSnackbar(res['message'] ?? 'Email sudah terdaftar. Silakan gunakan email lain.');
      }
    } catch (e) {
      isLoading.value = false;
      showErrorSnackbar('Gagal menghubungi server.');
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFEE2E2),
      colorText: const Color(0xFF991B1B),
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Color(0xFF991B1B),
      ),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

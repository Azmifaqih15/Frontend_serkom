import 'package:get/get.dart';
import 'api_service.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
    );
  }
}

class AuthService extends GetxService {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final _apiService = Get.find<ApiService>();



  bool get isGuest => currentUser.value == null || currentUser.value!.id == -1;

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _apiService.register(name, email, password);
      if (response.status.isOk) {
        return {'success': true};
      } else {
        final detail = response.body != null && response.body['detail'] != null
            ? response.body['detail']
            : 'Terjadi kesalahan saat registrasi';
        return {'success': false, 'message': detail};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response.status.isOk && response.body != null) {
        final token = response.body['access_token'];
        _apiService.tokenVal = token;

        final userResponse = await _apiService.getProfile();
        if (userResponse.status.isOk && userResponse.body != null) {
          currentUser.value = UserModel.fromJson(userResponse.body);
          return {'success': true};
        }
      }
      
      final detail = response.body != null && response.body['detail'] != null
          ? response.body['detail']
          : 'Email atau password salah';
      return {'success': false, 'message': detail};
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  void loginAsGuest() {
    currentUser.value = UserModel(
      id: -1,
      name: 'Tamu Essentials',
      email: 'guest@essentials.com',
      phone: '',
    );
  }

  Future<bool> updateProfile(String name, String phone) async {
    if (isGuest) return false;
    try {
      final response = await _apiService.updateProfile(name, phone);
      if (response.status.isOk && response.body != null) {
        currentUser.value = UserModel.fromJson(response.body);
        return true;
      }
    } catch (_) {}
    return false;
  }

  void logout() {
    currentUser.value = null;
    _apiService.tokenVal = null;
  }
}


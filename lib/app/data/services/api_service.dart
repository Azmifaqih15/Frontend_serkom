import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ApiService extends GetConnect {
  String? tokenVal;

  // Menggunakan USB Debugging via adb reverse tcp:8000 tcp:8000 (Sangat stabil & anti-gagal)
  static const String serverIp = '127.0.0.1'; 

  String get baseUrlString {
    if (kIsWeb) return 'http://localhost:8000';
    if (GetPlatform.isAndroid) {
      return 'http://$serverIp:8000';
    }
    return 'http://localhost:8000';
  }

  @override
  void onInit() {
    httpClient.baseUrl = baseUrlString;
    
    // Add Bearer token to all outgoing requests if token is set
    httpClient.addRequestModifier<dynamic>((request) {
      if (tokenVal != null && tokenVal!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $tokenVal';
      }
      return request;
    });

    // Configure default timeouts
    httpClient.timeout = const Duration(seconds: 15);
    
    super.onInit();
  }

  // ----------------- AUTH ENDPOINTS -----------------

  Future<Response> login(String email, String password) {
    return post('/auth/login', {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(String name, String email, String password, [String phone = '']) {
    return post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
  }

  Future<Response> getProfile() {
    return get('/auth/me');
  }

  Future<Response> updateProfile(String name, String phone) {
    return put('/auth/me', {
      'name': name,
      'phone': phone,
    });
  }

  // ----------------- PRODUCT ENDPOINTS -----------------

  Future<Response> getProducts({String? category, String? search}) {
    final Map<String, dynamic> query = {};
    if (category != null && category != 'Semua') {
      query['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }
    return get('/products', query: query);
  }

  // ----------------- CART ENDPOINTS -----------------

  Future<Response> getCart() {
    return get('/cart');
  }

  Future<Response> addToCart({
    required int productId,
    required String size,
    required String color,
    required int quantity,
  }) {
    return post('/cart', {
      'product_id': productId,
      'size': size,
      'color': color,
      'quantity': quantity,
    });
  }

  Future<Response> updateCartItem(int cartItemId, int quantity) {
    return put('/cart/$cartItemId', {
      'quantity': quantity,
    });
  }

  Future<Response> deleteCartItem(int cartItemId) {
    return delete('/cart/$cartItemId');
  }

  // ----------------- ORDER ENDPOINTS -----------------

  Future<Response> createOrder({
    required String name,
    required String phone,
    required String address,
    String? latitude,
    String? longitude,
    List<int>? cartItemIds,
  }) {
    final Map<String, dynamic> body = {
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
    if (cartItemIds != null && cartItemIds.isNotEmpty) {
      body['cart_item_ids'] = cartItemIds;
    }
    return post('/orders', body);
  }

  Future<Response> uploadPaymentProof(int orderId, String filename) {
    // Generate dummy bytes representing the image to upload
    final dummyBytes = List<int>.generate(100, (i) => i);
    final form = FormData({
      'file': MultipartFile(
        dummyBytes,
        filename: filename,
      ),
    });
    return post('/orders/$orderId/upload-payment', form);
  }

  Future<Response> getOrders() {
    return get('/orders');
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.8,
    this.stock = 50,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: parseDouble(json['price']),
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
      rating: json['rating'] != null ? parseDouble(json['rating']) : 4.8,
      stock: json['stock'] ?? 50,
    );
  }
}

class CartItem {
  final int? id;
  final Product product;
  final String size;
  final String color;
  final RxInt quantity;
  final RxBool isSelected;

  CartItem({
    this.id,
    required this.product,
    required this.size,
    required this.color,
    int quantity = 1,
    bool isSelected = false,
  }) : quantity = quantity.obs, isSelected = isSelected.obs;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(
              id: json['product_id'] ?? 0,
              name: 'Produk',
              price: 0,
              imageUrl: '',
              category: '',
            ),
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      quantity: json['quantity'] ?? 1,
      isSelected: false,
    );
  }
}

class OrderItemModel {
  final int? id;
  final String productName;
  final double price;
  final String imageUrl;
  final String size;
  final String color;
  final int quantity;

  OrderItemModel({
    this.id,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.color,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return OrderItemModel(
      id: json['id'],
      productName: json['product_name'] ?? '',
      price: parseDouble(json['price']),
      imageUrl: json['image_url'] ?? '',
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }
}

class OrderModel {
  final int? id;
  final String invoice;
  final String name;
  final String phone;
  final String address;
  final String latitude;
  final String longitude;
  final String buktiTransfer;
  final List<OrderItemModel> items;
  final double totalPayment;
  final DateTime orderDate;

  OrderModel({
    this.id,
    required this.invoice,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.buktiTransfer,
    required this.items,
    required this.totalPayment,
    required this.orderDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    var itemsList = <OrderItemModel>[];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(i))
          .toList();
    }

    String bukti = json['bukti_transfer'] ?? '';
    if (bukti.isNotEmpty && !bukti.startsWith('http')) {
      final apiService = Get.find<ApiService>();
      bukti = '${apiService.baseUrlString}/$bukti';
    }

    return OrderModel(
      id: json['id'],
      invoice: json['invoice'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      buktiTransfer: bukti,
      items: itemsList,
      totalPayment: parseDouble(json['total_payment']),
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : DateTime.now(),
    );
  }
}

class HomeController extends GetxController {
  final RxInt currentTabIndex = 0.obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;
  final RxString cariSearchQuery = ''.obs;
  final searchController = TextEditingController();

  final List<String> categories = [
    'Semua',
    'Cotton Combed',
    'Oversized',
    'Long Sleeve',
    'Relaxed Fit',
  ];

  final RxList<Product> allProducts = <Product>[
    Product(
      id: 1,
      name: 'Essential White Combed 24s',
      price: 149000,
      imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?auto=format&fit=crop&q=80&w=600', // White flat lay, no person
      category: 'Cotton Combed',
      rating: 4.8,
    ),
    Product(
      id: 2,
      name: 'Charcoal Oversized Boxy',
      price: 189000,
      imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?auto=format&fit=crop&q=80&w=600', // Charcoal folded, no person
      category: 'Oversized',
      rating: 4.9,
    ),
    Product(
      id: 3,
      name: 'Nero Long Sleeve Regular',
      price: 169000,
      imageUrl: 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?auto=format&fit=crop&q=80&w=600', // Black folded long sleeve, no person
      category: 'Long Sleeve',
      rating: 4.7,
    ),
    Product(
      id: 4,
      name: 'Earth Sand Cotton Relaxed',
      price: 155000,
      imageUrl: 'https://images.unsplash.com/photo-1622445262465-248197307559?auto=format&fit=crop&q=80&w=600', // Sand folded, no person
      category: 'Relaxed Fit',
      rating: 4.8,
    ),
    Product(
      id: 5,
      name: 'Heavy Cotton Classic',
      price: 249000,
      imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?auto=format&fit=crop&q=80&w=600', // White flat lay, no person
      category: 'Cotton Combed',
      rating: 4.6,
    ),
    Product(
      id: 6,
      name: 'Boxy Fit Premium Tee',
      price: 299000,
      imageUrl: 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&q=80&w=600', // Black flat lay, no person
      category: 'Oversized',
      rating: 4.9,
    ),
  ].obs;

  // Cart list (starts empty)
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Server order list
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final _apiService = Get.find<ApiService>();
  final _authService = Get.find<AuthService>();

  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingCart = false.obs;
  final RxBool isLoadingOrders = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cart starts empty
    cartItems.clear();

    // Fetch initial products
    fetchProducts();

    // Set up reactive listener for user auth changes
    ever(_authService.currentUser, (user) {
      if (user != null) {
        if (!_authService.isGuest) {
          fetchCart();
          fetchOrders();
        }
      } else {
        cartItems.clear();
        orders.clear();
      }
    });

    // If user is already logged in on startup
    if (_authService.currentUser.value != null && !_authService.isGuest) {
      fetchCart();
      fetchOrders();
    }
  }

  Future<void> fetchProducts() async {
    isLoadingProducts.value = true;
    try {
      final response = await _apiService.getProducts();
      if (response.status.isOk && response.body != null) {
        final List list = response.body;
        final loaded = list.map((item) => Product.fromJson(item)).toList();
        if (loaded.isNotEmpty) {
          allProducts.assignAll(loaded);
        }
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchCart() async {
    if (_authService.isGuest) return;
    isLoadingCart.value = true;
    try {
      final response = await _apiService.getCart();
      if (response.status.isOk && response.body != null) {
        final List list = response.body;
        final loaded = list.map((item) => CartItem.fromJson(item)).toList();
        cartItems.assignAll(loaded);
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<void> fetchOrders() async {
    if (_authService.isGuest) return;
    isLoadingOrders.value = true;
    try {
      final response = await _apiService.getOrders();
      if (response.status.isOk && response.body != null) {
        final List list = response.body;
        final loaded = list.map((item) => OrderModel.fromJson(item)).toList();
        orders.assignAll(loaded);
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  List<Product> get filteredProducts {
    final query = searchQuery.value.toLowerCase();
    return allProducts.where((product) {
      final matchesCategory = selectedCategory.value == 'Semua' || product.category == selectedCategory.value;
      final matchesSearch = product.name.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
    if (index == 0) {
      searchQuery.value = '';
      searchController.clear();
      fetchProducts();
    } else if (index == 2 && !_authService.isGuest) {
      fetchCart();
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    searchQuery.value = '';
    searchController.clear();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateCariSearchQuery(String query) {
    cariSearchQuery.value = query;
  }

  // Cart calculation helpers (only for selected items)
  double get subtotal => cartItems
      .where((item) => item.isSelected.value)
      .fold(0, (sum, item) => sum + (item.product.price * item.quantity.value));
  double get shippingFee => cartItems.where((item) => item.isSelected.value).isEmpty ? 0 : 15000;
  double get tax => subtotal * 0.11;
  double get totalPayment => subtotal + shippingFee + tax;

  Future<void> addProductToCart(Product product, String size, String color, {bool selectImmediately = false}) async {
    if (_authService.isGuest) {
      // Guest local-only cart behavior
      final existingIndex = cartItems.indexWhere((item) =>
          item.product.name == product.name &&
          item.size == size &&
          item.color == color);

      if (existingIndex != -1) {
        cartItems[existingIndex].quantity.value++;
        if (selectImmediately) {
          cartItems[existingIndex].isSelected.value = true;
        }
        cartItems.refresh();
      } else {
        cartItems.add(CartItem(
          product: product,
          size: size,
          color: color,
          quantity: 1,
          isSelected: selectImmediately,
        ));
      }
      Get.snackbar(
        'Keranjang Belanja',
        'Produk berhasil ditambahkan ke keranjang.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFECFDF5),
        colorText: const Color(0xFF065F46),
      );
      return;
    }

    try {
      final response = await _apiService.addToCart(
        productId: product.id,
        size: size,
        color: color,
        quantity: 1,
      );
      if (response.status.isOk) {
        await fetchCart();
        if (selectImmediately) {
          final targetIndex = cartItems.indexWhere((item) =>
              item.product.id == product.id &&
              item.size == size &&
              item.color == color);
          if (targetIndex != -1) {
            cartItems[targetIndex].isSelected.value = true;
          }
        }
        Get.snackbar(
          'Keranjang Belanja',
          'Produk berhasil ditambahkan ke keranjang.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFECFDF5),
          colorText: const Color(0xFF065F46),
        );
      } else {
        final detail = response.body != null && response.body['detail'] != null
            ? response.body['detail'].toString()
            : 'Gagal menambahkan ke keranjang (${response.statusCode})';
        Get.snackbar('Gagal', detail);
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal terhubung ke server: $e');
    }
  }

  Future<void> removeProductFromCart(CartItem item) async {
    if (_authService.isGuest || item.id == null) {
      cartItems.remove(item);
      cartItems.refresh();
      return;
    }

    try {
      final response = await _apiService.deleteCartItem(item.id!);
      if (response.status.isOk) {
        cartItems.remove(item);
        cartItems.refresh();
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal menghapus item dari keranjang',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
    }
  }

  Future<void> updateCartItemQuantity(CartItem item, int newQuantity) async {
    if (newQuantity < 1) return;
    item.quantity.value = newQuantity;
    cartItems.refresh();

    if (_authService.isGuest || item.id == null) {
      return;
    }

    try {
      final response = await _apiService.updateCartItem(item.id!, newQuantity);
      if (!response.status.isOk) {
        debugPrint('Failed to update cart item quantity on server');
      }
    } catch (e) {
      debugPrint('Error updating cart item quantity: $e');
    }
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

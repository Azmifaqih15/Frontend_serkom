import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_pages.dart';

class DetailProductController extends GetxController {
  late final Product product;

  final RxInt selectedColorIndex = 0.obs;
  final RxInt selectedSizeIndex = 1.obs; // Default to 'M' (index 1)
  final RxBool isFavorited = false.obs;
  
  final List<Map<String, dynamic>> colors = [
    {'name': 'Hitam', 'color': const Color(0xFF1C1C1C)},
    {'name': 'Putih', 'color': const Color(0xFFFFFFFF)},
    {'name': 'Slate Blue', 'color': const Color(0xFF506D90)},
    {'name': 'Deep Red', 'color': const Color(0xFF8B0D0D)},
  ];

  final List<String> sizes = ['S', 'M', 'L', 'XL'];

  final List<String> specifications = [
    'Bahan: 100% Cotton Combed 30s Premium',
    'Gramasi: 150-160 gsm (Sedang & Sejuk)',
    'Jahitan: Pundak rantai double-stitch rapi',
    'Potongan: Reguler Fit / Unisex',
    'Tekstur: Sangat halus & tidak menerawang'
  ];

  final List<String> careInstructions = [
    'Cuci dengan mesin/tangan menggunakan air dingin',
    'Cuci dengan warna yang senada',
    'Jangan menggunakan pemutih pakaian',
    'Setrika suhu sedang (balik baju saat menyetrika)',
    'Jangan diperas terlalu kuat agar serat tetap terjaga'
  ];

  @override
  void onInit() {
    super.onInit();
    // Safely fetch product passed through arguments
    if (Get.arguments is Product) {
      product = Get.arguments as Product;
    } else {
      // Fallback product in case page is loaded without arguments
      product = Product(
        id: 1,
        name: 'Essential White Combed 24s',
        price: 149000,
        imageUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?auto=format&fit=crop&q=80&w=600',
        category: 'Cotton Combed',
      );
    }
  }

  void toggleFavorite() {
    isFavorited.value = !isFavorited.value;
    Get.snackbar(
      isFavorited.value ? 'Wishlist' : 'Wishlist',
      isFavorited.value ? 'Produk ditambahkan ke wishlist' : 'Produk dihapus dari wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isFavorited.value ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
      colorText: isFavorited.value ? const Color(0xFF065F46) : const Color(0xFF991B1B),
      duration: const Duration(seconds: 1),
    );
  }

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  void shareProduct() {
    Get.snackbar(
      'Bagikan Produk',
      'Tautan produk berhasil disalin!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEFF6FF),
      colorText: const Color(0xFF1E40AF),
    );
  }

  Future<void> addToCart() async {
    try {
      final homeController = Get.find<HomeController>();
      final size = sizes[selectedSizeIndex.value];
      final color = colors[selectedColorIndex.value]['name'] as String;
      await homeController.addProductToCart(product, size, color);
    } catch (e) {
      debugPrint('Error in addToCart: $e');
    }
  }

  Future<void> buyNow() async {
    try {
      final homeController = Get.find<HomeController>();
      // Uncheck all other items in cart first so only the current product is checked out
      for (var item in homeController.cartItems) {
        item.isSelected.value = false;
      }

      final size = sizes[selectedSizeIndex.value];
      final color = colors[selectedColorIndex.value]['name'] as String;
      await homeController.addProductToCart(product, size, color, selectImmediately: true);

      Get.toNamed(Routes.CHECKOUT);
    } catch (e) {
      debugPrint('Error in buyNow: $e');
    }
  }
}


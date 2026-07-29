// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/colors.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});

  String _formatPrice(double price) {
    final val = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = val.length - 1; i >= 0; i--) {
      buffer.write(val[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'ESSENTIALS',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textPrimary,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ],
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.container,
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 10.0,
          bottom: 20.0,
        ),
        child: Row(
          children: [
            // Chat Item (Icon + Text)
            InkWell(
              onTap: () {
                Get.snackbar(
                  'Tanya Admin',
                  'Fitur chat dengan admin akan segera hadir',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.container,
                  colorText: AppColors.textPrimary,
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chat',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Vertical Divider Line
            Container(
              height: 28,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              color: AppColors.border,
            ),

            // Keranjang Item (Icon + Text)
            InkWell(
              onTap: controller.addToCart,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keranjang',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Beli Sekarang Button
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.buyNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonTextPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Beli Sekarang',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image & Wishlist/Share buttons
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 420,
                  color: AppColors.container,
                  child: Image.network(
                    controller.product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                          strokeWidth: 2.5,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                // Heart & Share floating circular buttons
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Heart button
                      Obx(
                        () => GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: AppColors.container,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              controller.isFavorited.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: controller.isFavorited.value
                                  ? const Color(0xFFDC2626)
                                  : AppColors.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Share button
                      GestureDetector(
                        onTap: controller.shareProduct,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AppColors.container,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.share_outlined,
                            color: AppColors.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Product Details Block
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collection tag
                  Text(
                    'KOLEKSI INTI',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Product title
                  Text(
                    controller.product.name,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rp ${_formatPrice(controller.product.price)}',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Rp 199.000',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text(
                    'Dirancang untuk kenyamanan sehari-hari. Bahan katun combed 30s kami menawarkan keseimbangan terbaik antara sirkulasi udara dan daya tahan. Dilengkapi kerah bulat yang diperkuat dan potongan yang tetap rapi meski sudah dicuci berkali-kali.',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Color Picker
                  Row(
                    children: [
                      Text(
                        'Warna: ',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.colors[controller.selectedColorIndex.value]['name'],
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Color options row
                  SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.colors.length,
                      itemBuilder: (context, index) {
                        final colorItem = controller.colors[index];
                        return Obx(() {
                          final isSelected = controller.selectedColorIndex.value == index;
                          return GestureDetector(
                            onTap: () => controller.selectColor(index),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.accent
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorItem['color'],
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Size Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih Ukuran',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              backgroundColor: AppColors.container,
                              title: Text('Panduan Ukuran', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              content: Text(
                                'S: Lebar 47 cm, Panjang 67 cm\nM: Lebar 50 cm, Panjang 70 cm\nL: Lebar 53 cm, Panjang 73 cm\nXL: Lebar 56 cm, Panjang 75 cm',
                                style: GoogleFonts.outfit(height: 1.6, color: AppColors.textSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text('Tutup', style: GoogleFonts.outfit(color: AppColors.accent)),
                                )
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'Panduan Ukuran',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Size options row
                  Row(
                    children: List.generate(
                      controller.sizes.length,
                      (index) {
                        final size = controller.sizes[index];
                        return Obx(() {
                          final isSelected = controller.selectedSizeIndex.value == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () => controller.selectSize(index),
                              child: Container(
                                width: 50,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.container,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.accent
                                        : AppColors.border,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? AppColors.buttonTextPrimary : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Feature Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.container,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.waves_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '100% Katun',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Serat alami yang sejuk',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.container,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.architecture_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '30s Combed',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tekstur lembut & tahan lama',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.border, thickness: 1),

                  // Expansion Panels (Accordions)
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          iconColor: AppColors.textPrimary,
                          collapsedIconColor: AppColors.textSecondary,
                          title: Text(
                            'SPESIFIKASI',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          children: controller.specifications.map((spec) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 6,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      spec,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Divider(color: AppColors.border, thickness: 1),
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          iconColor: AppColors.textPrimary,
                          collapsedIconColor: AppColors.textSecondary,
                          title: Text(
                            'PANDUAN PERAWATAN',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          children: controller.careInstructions.map((instruction) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 6,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      instruction,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

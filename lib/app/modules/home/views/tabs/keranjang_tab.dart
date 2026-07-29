// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/colors.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';

class KeranjangTab extends GetView<HomeController> {
  const KeranjangTab({super.key});

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
        title: Text(
          'Keranjang Belanja',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState();
        }
        return _buildCartContent();
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.container,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Keranjang Anda Kosong',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mulai belanja kaos polos premium berkualitas terbaik sekarang.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: () => controller.changeTab(0), // Back to Toko tab
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.buttonTextPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Mulai Belanja',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              final item = controller.cartItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.container,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      // Checkbox Selection
                      Obx(() => Checkbox(
                            value: item.isSelected.value,
                            activeColor: AppColors.accent,
                            checkColor: const Color(0xFF080E1E),
                            side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                item.isSelected.value = val;
                                controller.cartItems.refresh();
                              }
                            },
                          )),
                      const SizedBox(width: 4),
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details (Title, color, size, price)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Warna: ${item.color}  •  Ukuran: ${item.size}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${_formatPrice(item.product.price)}',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quantity control & Delete button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                            onPressed: () => controller.removeProductFromCart(item),
                          ),
                          Row(
                            children: [
                              // Minus button
                              GestureDetector(
                                onTap: () {
                                  if (item.quantity.value > 1) {
                                    controller.updateCartItemQuantity(item, item.quantity.value - 1);
                                  }
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.background,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove, size: 14, color: AppColors.textPrimary),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Obx(
                                  () => Text(
                                    '${item.quantity.value}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              // Plus button
                              GestureDetector(
                                onTap: () {
                                  controller.updateCartItemQuantity(item, item.quantity.value + 1);
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.background,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.add, size: 14, color: AppColors.textPrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Summary & Checkout footer
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: AppColors.container,
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1.0),
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(() => Text(
                        'Rp ${_formatPrice(controller.subtotal)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Pengiriman',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(() => Text(
                        'Rp ${_formatPrice(controller.shippingFee)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pajak (11%)',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(() => Text(
                        'Rp ${_formatPrice(controller.tax)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.border, thickness: 1.2),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Obx(() => Text(
                        'Rp ${_formatPrice(controller.totalPayment)}',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                final hasSelected = controller.cartItems.any((item) => item.isSelected.value);
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: hasSelected ? () => Get.toNamed(Routes.CHECKOUT) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasSelected ? AppColors.buttonPrimary : AppColors.border,
                      foregroundColor: hasSelected ? AppColors.buttonTextPrimary : AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Lanjutkan ke Checkout',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

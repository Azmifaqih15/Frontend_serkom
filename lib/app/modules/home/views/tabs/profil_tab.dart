// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/colors.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';

class ProfilTab extends GetView<HomeController> {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil Saya',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 28),
            // User Avatar + Details
            Obx(() {
              final user = authService.currentUser.value;
              final name = user?.name ?? 'Tamu Essentials';
              final email = user?.email ?? 'guest@essentials.com';
              final initial = name.isNotEmpty ? name[0].toUpperCase() : 'G';

              return Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonTextPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 36),

            // --- SECTION: STATISTIK TRANSAKSI ---
            Obx(() {
              final totalTransactions = controller.orders.length;
              final totalSpent = controller.orders.fold(0.0, (sum, order) => sum + order.totalPayment);
              final totalItems = controller.orders.fold(0, (sum, order) => sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));

              String formatPrice(double price) {
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

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.container,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Col 1: Transaksi
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.accent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$totalTransactions',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Transaksi',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Container(
                      height: 50,
                      width: 1,
                      color: AppColors.border,
                    ),
                    // Col 2: Total Belanja
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.payments_outlined,
                              color: AppColors.accent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rp ${formatPrice(totalSpent)}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Belanja',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Container(
                      height: 50,
                      width: 1,
                      color: AppColors.border,
                    ),
                    // Col 3: Total Barang
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.check_box_outlined,
                              color: AppColors.accent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$totalItems',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Item Dibeli',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 28),

            // Profile Items
            _buildProfileMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Edit Profil',
              onTap: () => Get.toNamed(Routes.EDIT_PROFIL),
            ),
            _buildProfileMenuItem(
              icon: Icons.credit_card_outlined,
              title: 'Metode Pembayaran',
              onTap: () => Get.toNamed(Routes.METODE_PEMBAYARAN),
            ),
            _buildProfileMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Data Pesanan',
              onTap: () => Get.toNamed(Routes.ADMIN_ORDERS),
            ),
            _buildProfileMenuItem(
              icon: Icons.help_outline_rounded,
              title: 'Hubungi Kami',
              onTap: () => Get.toNamed(Routes.HUBUNGI_KAMI),
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, thickness: 1),
            const SizedBox(height: 20),
            // Logout Button
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C1B1B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                ),
              ),
              title: Text(
                'Keluar',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF4444),
                ),
              ),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.container,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Icon(
            icon,
            color: AppColors.accent,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}

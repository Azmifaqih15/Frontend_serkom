import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/colors.dart';

class HubungiKamiView extends StatelessWidget {
  const HubungiKamiView({super.key});

  void _copyToClipboard(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    Get.snackbar(
      'Salin Berhasil',
      '$label telah disalin ke papan klip',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFECFDF5),
      colorText: const Color(0xFF065F46),
      icon: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF065F46)),
      duration: const Duration(seconds: 2),
    );
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
          'Hubungi Kami',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layanan Bantuan Pelanggan',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ada pertanyaan atau mengalami kendala pemesanan? Tim Customer Service Essentials siap membantu Anda.',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // WhatsApp Card
            _buildContactCard(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'WhatsApp Support',
              value: '+62 812-3456-7890',
              subtitle: 'Respon cepat • Jam operasional',
            ),
            const SizedBox(height: 16),

            // Email Card
            _buildContactCard(
              icon: Icons.alternate_email_rounded,
              title: 'Email Dukungan',
              value: 'support@essentials.co.id',
              subtitle: 'Hubungi kami via email formal',
            ),
            const SizedBox(height: 16),

            // Instagram Card
            _buildContactCard(
              icon: Icons.camera_alt_outlined,
              title: 'Instagram Resmi',
              value: '@essentials.polos',
              subtitle: 'Ikuti update produk terbaru kami',
            ),
            const SizedBox(height: 16),

            // Store Address Card
            _buildContactCard(
              icon: Icons.store_mall_directory_outlined,
              title: 'Toko Fisik / Kantor Pusat',
              value: 'Jl. Merdeka No. 10, Gambir, Jakarta Pusat, DKI Jakarta - 10110',
              subtitle: 'Kunjungi toko offline kami',
            ),
            const SizedBox(height: 36),

            // Operational Hours Box
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.container,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam Operasional Dukungan',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Senin - Sabtu: 09:00 - 18:00 WIB\n(Hari Minggu & Tanggal Merah Libur)',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
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

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Icon(
              icon,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.copy_rounded,
              color: AppColors.accent,
              size: 20,
            ),
            onPressed: () => _copyToClipboard(title, value),
            tooltip: 'Salin Kontak',
          ),
        ],
      ),
    );
  }
}

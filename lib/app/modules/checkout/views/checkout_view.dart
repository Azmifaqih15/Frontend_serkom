// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/colors.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

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
    // Access HomeController for cart data
    final homeController = Get.find<HomeController>();

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
          'Checkout',
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
          left: 20.0,
          right: 20.0,
          top: 16.0,
          bottom: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total Price info on left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Text(
                    'Rp ${_formatPrice(homeController.totalPayment)}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
            // Checkout button on right
            SizedBox(
              width: 180,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.pesanSekarang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.buttonTextPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Pesan Sekarang',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: DATA PRIBADI ---
            Text(
              'Data Pribadi',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputLabel('NAMA LENGKAP'),
            _buildInputField(
              controller: controller.nameController,
              hint: 'Contoh: John Doe',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _buildInputLabel('NOMOR TELEPON'),
            _buildInputField(
              controller: controller.phoneController,
              hint: '+62 812...',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 28),

            // --- SECTION 2: ALAMAT PENGIRIMAN ---
            Text(
              'Alamat Pengiriman',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputLabel('PROVINSI'),
            _buildInputField(
              controller: controller.provinceController,
              hint: 'Pilih Provinsi',
            ),
            const SizedBox(height: 16),
            _buildInputLabel('KOTA / KABUPATEN'),
            _buildInputField(
              controller: controller.cityController,
              hint: 'Pilih Kota/Kabupaten',
            ),
            const SizedBox(height: 16),
            _buildInputLabel('KECAMATAN'),
            _buildInputField(
              controller: controller.districtController,
              hint: 'Pilih Kecamatan',
            ),
            const SizedBox(height: 16),
            _buildInputLabel('KODE POS'),
            _buildInputField(
              controller: controller.zipCodeController,
              hint: 'Contoh: 12345',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildInputLabel('ALAMAT LENGKAP (NAMA JALAN)'),
            _buildInputField(
              controller: controller.addressController,
              hint: 'Contoh: Jl. Thamrin Raya No. 42',
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 16),
            _buildInputLabel('DETAIL ALAMAT (NOMOR RUMAH/LANTAI)'),
            _buildInputField(
              controller: controller.detailAddressController,
              hint: 'Masukkan detail patokan atau instruksi khusus...',
              maxLines: 2,
            ),
            const SizedBox(height: 28),

            // --- SECTION 2.5: LOKASI GPS ---
            Text(
              'Lokasi GPS',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('LATITUDE'),
                      _buildInputField(
                        controller: controller.latitudeController,
                        hint: 'Latitude',
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('LONGITUDE'),
                      _buildInputField(
                        controller: controller.longitudeController,
                        hint: 'Longitude',
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoadingLocation.value
                      ? null
                      : controller.getCurrentLocation,
                  icon: controller.isLoadingLocation.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.my_location_rounded, size: 20),
                  label: Text(
                    controller.isLoadingLocation.value
                        ? 'Mengambil Lokasi...'
                        : 'Dapatkan Koordinat GPS',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonSecondary,
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // --- SECTION 3: METODE PEMBAYARAN ---
            Text(
              'Metode Pembayaran: Transfer Bank & Unggah Bukti',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Dotted upload area
            Obx(() {
              final uploadedName = controller.buktiTransferName.value;
              return GestureDetector(
                onTap: uploadedName == null ? controller.pickBuktiTransfer : null,
                child: CustomPaint(
                  painter: DashedBorderPainter(
                    color: uploadedName != null ? const Color(0xFF10B981) : AppColors.border,
                    strokeWidth: 1.5,
                    gap: 6.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.container,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: uploadedName != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  uploadedName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Color(0xFFEF4444)),
                                onPressed: controller.removeBuktiTransfer,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const Icon(
                                Icons.insert_drive_file_outlined,
                                size: 36,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Ketuk untuk unggah atau seret gambar bukti transfer di sini',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Format: JPG, PNG (Maks. 5MB)',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            // Info account banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.container,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Informasi Rekening\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Bank BCA 1234567890 a/n PT ESSENTIALS INDONESIA',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // --- SECTION 4: RINGKASAN PESANAN ---
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.container,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Pesanan',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List of cart items
                  Obx(
                    () {
                      final selectedItems = homeController.cartItems.where((item) => item.isSelected.value).toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedItems.length,
                        itemBuilder: (context, index) {
                          final item = selectedItems[index];
                          return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.color}  •  ${item.size}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${item.quantity.value}x',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Rp ${_formatPrice(item.product.price * item.quantity.value)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border, thickness: 1.2),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Subtotal', homeController.subtotal),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Biaya Pengiriman', homeController.shippingFee),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Pajak (11%)', homeController.tax),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border, thickness: 1.2),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Rp ${_formatPrice(homeController.totalPayment)}',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(
            color: AppColors.fieldHint,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Rp ${_formatPrice(value)}',
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// Custom Painter to draw a dashed border around the upload container
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    this.color = const Color(0xFF8A9AAB),
    this.strokeWidth = 1.5,
    this.gap = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Round rect with radius 12 matching screenshot
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    ));

    final dashPath = _buildDashPath(path, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashPath(Path source, double gap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = gap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}

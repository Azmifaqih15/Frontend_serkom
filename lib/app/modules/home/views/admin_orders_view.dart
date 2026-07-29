import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/colors.dart';
import '../controllers/home_controller.dart';

class AdminOrdersView extends GetView<HomeController> {
  const AdminOrdersView({super.key});

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
          'Panel Admin (Data Pesanan)',
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
        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Pesanan Masuk',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }

        // Sort orders so the newest shows first
        final sortedOrders = List<OrderModel>.from(controller.orders)
          ..sort((a, b) => b.orderDate.compareTo(a.orderDate));

        return ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: sortedOrders.length,
          itemBuilder: (context, index) {
            final order = sortedOrders[index];
            final formattedDate = "${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year} ${order.orderDate.hour.toString().padLeft(2, '0')}:${order.orderDate.minute.toString().padLeft(2, '0')}";

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
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
                    // Invoice ID & Date Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.invoice,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.border, thickness: 1, height: 24),

                    // Customer Details
                    _buildDetailRow(Icons.person_rounded, 'Pelanggan', order.name),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.phone_android_rounded, 'Nomor HP', order.phone),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.location_on_rounded, 'Alamat', order.address),
                    const SizedBox(height: 10),

                    // GPS Coordinates Section
                    _buildDetailRow(
                      Icons.my_location_rounded,
                      'GPS Koordinat',
                      'Lat: ${order.latitude}\nLng: ${order.longitude}',
                      action: TextButton.icon(
                        onPressed: () {
                          final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}';
                          Clipboard.setData(ClipboardData(text: mapsUrl));
                          Get.dialog(
                            AlertDialog(
                              backgroundColor: AppColors.container,
                              title: Text(
                                'Koordinat GPS Pelanggan',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Latitude: ${order.latitude}',
                                    style: GoogleFonts.outfit(color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Longitude: ${order.longitude}',
                                    style: GoogleFonts.outfit(color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Link Google Maps telah disalin ke papan klip Anda!',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.accent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Tutup',
                                    style: GoogleFonts.outfit(color: AppColors.accent),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.accent),
                        label: Text(
                          'Salin Tautan Maps',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Bukti Pembayaran
                    _buildDetailRow(
                      Icons.receipt_outlined,
                      'Bukti Transfer',
                      order.buktiTransfer,
                      valueColor: Colors.greenAccent,
                    ),
                    const Divider(color: AppColors.border, thickness: 1, height: 28),

                    // Items List
                    Text(
                      'Rincian Produk:',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      itemBuilder: (context, iIndex) {
                        final item = order.items[iIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
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
                                '${item.quantity}x',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Rp ${_formatPrice(item.price * item.quantity)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border, thickness: 1, height: 28),

                    // Total Payment Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Rp ${_formatPrice(order.totalPayment)}',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    Widget? action,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: 4),
                action,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

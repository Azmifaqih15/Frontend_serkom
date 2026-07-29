import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/colors.dart';

class CheckoutController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final _authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();
  final detailAddressController = TextEditingController();

  // GPS Coordinates
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final RxBool isLoadingLocation = false.obs;

  final RxnString buktiTransferName = RxnString(); // Holds the name of the simulated uploaded file

  void pickBuktiTransfer() {
    // Simulate picking an image file
    buktiTransferName.value = 'bukti_transfer_bca_249.jpg';
    Get.snackbar(
      'Unggah Berhasil',
      'Bukti transfer berhasil diunggah',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFECFDF5),
      colorText: const Color(0xFF065F46),
      duration: const Duration(seconds: 2),
    );
  }

  void removeBuktiTransfer() {
    buktiTransferName.value = null;
  }

  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Layanan Lokasi Mati',
          'Mohon aktifkan GPS/layanan lokasi Anda',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFEF2F2),
          colorText: const Color(0xFF991B1B),
        );
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Izin Ditolak',
            'Aplikasi membutuhkan izin lokasi untuk mengambil koordinat GPS',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFEF2F2),
            colorText: const Color(0xFF991B1B),
          );
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Izin Ditolak Permanen',
          'Mohon izinkan akses lokasi melalui pengaturan aplikasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFEF2F2),
          colorText: const Color(0xFF991B1B),
        );
        isLoadingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();

      // Reverse geocoding to fill address fields
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;
          
          provinceController.text = place.administrativeArea ?? 'DKI Jakarta';
          cityController.text = place.locality ?? place.subAdministrativeArea ?? 'Jakarta Selatan';
          districtController.text = place.subLocality ?? 'Kebayoran Baru';
          zipCodeController.text = place.postalCode ?? '12110';
          
          List<String> streetParts = [];
          if (place.street != null && place.street!.isNotEmpty) {
            streetParts.add(place.street!);
          } else {
            if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
              streetParts.add(place.thoroughfare!);
            }
            if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
              streetParts.add(place.subThoroughfare!);
            }
          }
          addressController.text = streetParts.isNotEmpty ? streetParts.join(', ') : 'Jl. Trunojoyo No. 3';
        } else {
          _fillMockAddress();
        }
      } catch (e) {
        debugPrint('Reverse geocoding error: $e');
        _fillMockAddress();
      }

      Get.snackbar(
        'Lokasi & Alamat Didapatkan',
        'Koordinat GPS dan alamat pengiriman berhasil diambil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFECFDF5),
        colorText: const Color(0xFF065F46),
      );
    } catch (e) {
      Get.snackbar(
        'Error GPS',
        'Gagal mengambil lokasi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void _fillMockAddress() {
    provinceController.text = 'DKI Jakarta';
    cityController.text = 'Jakarta Selatan';
    districtController.text = 'Kebayoran Baru';
    zipCodeController.text = '12110';
    addressController.text = 'Jl. Trunojoyo No. 3';
  }

  void pesanSekarang() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final lat = latitudeController.text.trim();
    final lng = longitudeController.text.trim();

    if (name.isEmpty || phone.isEmpty || address.isEmpty || lat.isEmpty || lng.isEmpty) {
      Get.snackbar(
        'Formulir Belum Lengkap',
        'Mohon lengkapi Nama, Telepon, Alamat Pengiriman, dan Koordinat GPS',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
      return;
    }

    if (buktiTransferName.value == null) {
      Get.snackbar(
        'Bukti Transfer Kosong',
        'Mohon unggah bukti transfer pembayaran terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
      return;
    }

    final homeController = Get.find<HomeController>();

    if (_authService.isGuest) {
      // For Guest user, keep mock checkout behavior
      try {
        final invoiceNum = 'INV/${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}/ESS/${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
        final selectedItems = homeController.cartItems.where((item) => item.isSelected.value).toList();
        final orderItems = selectedItems.map((item) {
          return OrderItemModel(
            productName: item.product.name,
            price: item.product.price,
            imageUrl: item.product.imageUrl,
            size: item.size,
            color: item.color,
            quantity: item.quantity.value,
          );
        }).toList();

        final fullAddress = '$address, ${detailAddressController.text.trim()} (${districtController.text.trim()}, ${cityController.text.trim()}, ${provinceController.text.trim()} - ${zipCodeController.text.trim()})';

        final newOrder = OrderModel(
          invoice: invoiceNum,
          name: name,
          phone: phone,
          address: fullAddress,
          latitude: lat,
          longitude: lng,
          buktiTransfer: buktiTransferName.value ?? '',
          items: orderItems,
          totalPayment: homeController.totalPayment,
          orderDate: DateTime.now(),
        );

        homeController.orders.add(newOrder);
        homeController.cartItems.removeWhere((item) => item.isSelected.value);
        Get.offAllNamed(Routes.CHECKOUT_SUCCESS);
      } catch (e) {
        Get.snackbar('Gagal', 'Gagal memproses pesanan lokal: $e');
      }
      return;
    }

    // For Authenticated user, connect to real REST API
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      barrierDismissible: false,
    );

    try {
      final fullAddress = '$address, ${detailAddressController.text.trim()} (${districtController.text.trim()}, ${cityController.text.trim()}, ${provinceController.text.trim()} - ${zipCodeController.text.trim()})';

      // Extract selected cart item IDs
      final selectedCartItemIds = homeController.cartItems
          .where((item) => item.isSelected.value && item.id != null)
          .map((item) => item.id!)
          .toList();

      // 1. Create order on FastAPI backend
      final orderResponse = await _apiService.createOrder(
        name: name,
        phone: phone,
        address: fullAddress,
        latitude: lat,
        longitude: lng,
        cartItemIds: selectedCartItemIds,
      );

      if (!orderResponse.status.isOk || orderResponse.body == null) {
        Get.back(); // close progress dialog
        final detail = orderResponse.body != null && orderResponse.body['detail'] != null
            ? orderResponse.body['detail']
            : 'Gagal membuat pesanan di server';
        Get.snackbar(
          'Kesalahan',
          detail,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFEF2F2),
          colorText: const Color(0xFF991B1B),
        );
        return;
      }

      final createdOrderJson = orderResponse.body;
      final int orderId = createdOrderJson['id'];

      // 2. Upload payment proof to FastAPI backend
      final uploadResponse = await _apiService.uploadPaymentProof(
        orderId,
        buktiTransferName.value!,
      );

      Get.back(); // close progress dialog

      if (!uploadResponse.status.isOk) {
        Get.snackbar(
          'Bukti Transfer Gagal',
          'Pesanan dibuat tetapi gagal mengunggah bukti transfer.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFEF2F2),
          colorText: const Color(0xFF991B1B),
        );
        return;
      }

      // 3. Clear local selected items and refresh orders from database
      homeController.fetchCart();
      homeController.fetchOrders();

      Get.offAllNamed(Routes.CHECKOUT_SUCCESS);
    } catch (e) {
      Get.back(); // close progress dialog
      Get.snackbar(
        'Kesalahan',
        'Gagal memproses pesanan ke server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    provinceController.dispose();
    cityController.dispose();
    districtController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    detailAddressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}

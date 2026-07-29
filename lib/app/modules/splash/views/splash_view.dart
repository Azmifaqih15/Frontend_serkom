import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Center Content (Icon + Brand Name + Subtitle)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hanger Icon using CustomPaint
                  CustomPaint(
                    size: const Size(130, 90),
                    painter: HangerPainter(),
                  ),
                  const SizedBox(height: 40),
                  // Brand Title
                  Text(
                    'ESSENTIALS',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Kualitas Terbaik untuk Anda',
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 4),
            // Bottom Content (Next Button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => controller.navigateToLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonTextPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27), // Rounded pill button
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HangerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final double w = size.width;
    final double h = size.height;

    // Center coordinates for hook and neck base
    final double centerX = w * 0.5;
    
    // Bottom coordinates of the triangle base
    final double baseLeftX = w * 0.12;
    final double baseRightX = w * 0.88;
    final double baseBottomY = h * 0.78;
    
    // Top of the triangle (where hook neck starts)
    final double triangleTopY = h * 0.48;

    // Draw the hanger triangle base
    path.moveTo(centerX, triangleTopY);
    path.lineTo(baseLeftX, baseBottomY);
    path.lineTo(baseRightX, baseBottomY);
    path.close();

    // Draw neck going up
    final double neckTopY = h * 0.40;
    path.moveTo(centerX, triangleTopY);
    path.lineTo(centerX, neckTopY);

    // Draw the curved hook
    // Starts at neckTopY, goes up-left, curves right and up, loops down and right, and ends open
    path.cubicTo(
      centerX - w * 0.06, neckTopY - h * 0.02,
      centerX - w * 0.10, neckTopY - h * 0.15,
      centerX, neckTopY - h * 0.22,
    );
    path.cubicTo(
      centerX + w * 0.10, neckTopY - h * 0.29,
      centerX + w * 0.18, neckTopY - h * 0.13,
      centerX + w * 0.08, neckTopY - h * 0.06,
    );
    path.cubicTo(
      centerX + w * 0.04, neckTopY - h * 0.03,
      centerX + w * 0.01, neckTopY - h * 0.04,
      centerX, neckTopY - h * 0.08,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

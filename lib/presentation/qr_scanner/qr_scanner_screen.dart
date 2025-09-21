import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double scanBoxSize = 280;

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          final scanWindow = Rect.fromCenter(
            center: Offset(width / 2, height / 2),
            width: scanBoxSize,
            height: scanBoxSize,
          );

          return Stack(
            children: [
              /// Camera feed
              MobileScanner(
                controller: controller,
                scanWindow: scanWindow,
                fit: BoxFit.cover,
                onDetect: (capture) async {
                  if (isScanned) return;
                  isScanned = true;
                  final String? code = capture.barcodes.first.rawValue;
                  if (code != null) {
                    await controller.stop();
                    if (mounted) {
                      Navigator.pop(context, code);
                    }
                  }
                },
              ),

              /// Blur overlay except scan box
              Positioned.fill(
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: _HoleClipper(scanWindow),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(color: Colors.black.withOpacity(0)),
                      ),
                    ),
                    // Box border
                    Positioned.fromRect(
                      rect: scanWindow,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.8),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Neon scanning line
              Positioned.fromRect(
                rect: scanWindow,
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment(
                        0,
                        _animController.value * 2 - 1,
                      ),
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.cyanAccent, Colors.blueAccent],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.8),
                              blurRadius: 12,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Instruction text
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: const Text(
                  "Align the QR inside the frame to scan",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              /// Top buttons
              Positioned(
                top: 50,
                left: 20,
                child: FloatingActionButton(
                  heroTag: "closeBtn",
                  mini: true,
                  backgroundColor: Colors.black54,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: FloatingActionButton(
                  heroTag: "flashBtn",
                  mini: true,
                  backgroundColor: Colors.black54,
                  onPressed: () => controller.toggleTorch(),
                  child: const Icon(Icons.flash_on, color: Colors.yellowAccent),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Clipper that creates a transparent hole (QR window)
class _HoleClipper extends CustomClipper<Path> {
  final Rect hole;
  _HoleClipper(this.hole);

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(20)))
        ..close(),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

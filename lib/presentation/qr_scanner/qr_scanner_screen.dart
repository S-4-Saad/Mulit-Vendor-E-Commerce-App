import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/services/permission_service.dart';
import '../../widgets/dialog_boxes/permission_dialog.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;
  bool hasPermission = false;
  bool isCheckingPermission = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final granted = await PermissionService.isCameraPermissionGranted();
    
    if (!granted) {
      // Show permission dialog
      if (!mounted) return;
      final shouldRequest = await PermissionDialog.showCameraPermissionDialog(context);
      
      if (shouldRequest == true) {
        final permissionGranted = await PermissionService.requestCameraPermission();
        
        if (!mounted) return;
        setState(() {
          hasPermission = permissionGranted;
          isCheckingPermission = false;
        });
        
        if (!permissionGranted) {
          // Check if permanently denied
          if (!mounted) return;
          await PermissionDialog.showCameraPermissionDeniedDialog(
            context,
            isPermanentlyDenied: true,
          );
          if (!mounted) return;
          Navigator.pop(context);
        }
      } else {
        // User declined permission
        if (!mounted) return;
        Navigator.pop(context);
      }
    } else {
      if (!mounted) return;
      setState(() {
        hasPermission = true;
        isCheckingPermission = false;
      });
    }
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

    // Show loading while checking permission
    if (isCheckingPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.cyanAccent),
              SizedBox(height: 16),
              Text(
                'Checking camera permission...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    // Show error if no permission
    if (!hasPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.no_photography,
                color: Colors.white70,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Camera permission is required\nto scan QR codes',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

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


import 'package:flutter/material.dart';
import 'package:speezu/core/assets/font_family.dart';


class SnackBarHelper {
  static void showTopSnackBar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.green,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewPadding.top + 10,
        left: 20,
        right: 20,
        child: SlideInSnackBar(
          message: message,
          backgroundColor: backgroundColor,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  static void showSuccess(BuildContext context, String message) {
    showTopSnackBar(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  static void showError(BuildContext context, String message) {
    showTopSnackBar(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
}

class SlideInSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const SlideInSnackBar({
    Key? key,
    required this.message,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<SlideInSnackBar> createState() => _SlideInSnackBarState();
}

class _SlideInSnackBarState extends State<SlideInSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(10),
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            widget.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: FontFamily.fontsPoppinsRegular,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/assets/font_family.dart';

class OtpInputWidget extends StatefulWidget {
  final Function(String) onCompleted;
  final int length;
  const OtpInputWidget({super.key, required this.onCompleted, this.length = 6});
  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - unfocus and call completion
        _focusNodes[index].unfocus();
      }
    }
    // Check if all fields are filled
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) => _buildOTPField(index)),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _focusNodes[index].hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontFamily: FontFamily.fontsPoppinsSemiBold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _onChanged(value, index),
        onTap: () {
          // Clear the field when tapped to allow re-entry
          _controllers[index].clear();
        },
        onFieldSubmitted: (_) {
          if (index < widget.length - 1) {
            _focusNodes[index + 1].requestFocus();
          }
        },
        onEditingComplete: () {
          // Handle backspace on empty field
          _onBackspace(index);
        },
      ),
    );
  }
}

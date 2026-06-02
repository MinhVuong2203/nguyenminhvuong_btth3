import 'package:flutter/material.dart';
import 'package:nguyenminhvuong_btth3/utils/app_color.dart';

class BtnPrimary extends StatelessWidget {
  final String text;
  final double? width;
  final VoidCallback onPressed;

  const BtnPrimary({
    super.key,
    required this.text,
    this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
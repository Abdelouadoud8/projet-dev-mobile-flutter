import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed; // Optional callback for onPressed

  const PrimaryButton({
    Key? key,
    this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(342, 52),
        primary: Color(0xFF8F42F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label ?? 'Update Threshold',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

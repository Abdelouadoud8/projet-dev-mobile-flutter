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
      onPressed: onPressed, // Call the onPressed callback when the button is pressed
      style: ElevatedButton.styleFrom(
        minimumSize: Size(342, 52),
        primary: Color(0xFF2F80ED),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label ?? 'Update Threshold', // Use the provided label or a default one
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

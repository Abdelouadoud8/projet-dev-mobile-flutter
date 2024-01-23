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
    return Container(
      width: 342,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: ShapeDecoration(
        color: Color(0xFF2F80ED),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Update Threshold',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
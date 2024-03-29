import 'package:flutter/material.dart';

class ThresholdBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed; // Optional callback for onPressed

  const ThresholdBox({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFFFCFCFC),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFFF0F2FF),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Color(0xFF8F42F1),
                  ),
                ),
                SizedBox(height:8),
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height:8),
              ],
            ),
          )
      ),
    );
  }
}
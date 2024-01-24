import 'package:flutter/material.dart';

class ThresholdBox extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final VoidCallback? onPressed; // Optional callback for onPressed

  const ThresholdBox({
    Key? key,
    required this.label,
    required this.value,
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
                    color: Color(0xFF0578FF),
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
                Row(
                  children: [
                    Text(
                      'Threshold: $value',
                      style: TextStyle(
                        color: Color(0xFF7E7E7E),
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width:4),
                    Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 20,
                      color: Color(0xFF7E7E7E), // You can adjust the icon color
                    ),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}
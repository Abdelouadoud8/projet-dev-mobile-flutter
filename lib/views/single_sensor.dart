import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/sensor_data.dart';

class SingleSensor extends StatelessWidget {
  final SensorData sensorData;
  final String label;
  final IconData icon;
  final Color color;

  const SingleSensor({
    Key? key,
    required this.label,
    /* required this.value,
    required this.unit, */
    required this.sensorData,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8D8D8D),
            fontSize: 16,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '${sensorData.value.toStringAsFixed(2)} ${sensorData.unit}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF262626),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
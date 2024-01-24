import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_mobile/views/single_sensor.dart';

import '../cubit/sensor_bloc.dart';

/// Sensors Values ///
class SensorsBox extends StatefulWidget {
  @override
  _SensorsBoxState createState() => _SensorsBoxState();
}

class _SensorsBoxState extends State<SensorsBox> {
  late Timer _timer; // Declare a Timer
  late SensorBloc sensorBloc;

  @override
  void initState() {
    super.initState();
    // Initialize the timer here and start it
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      // Dispatch the fetch event to the SensorBloc
      context.read<SensorBloc>().add(SensorEvent.fetch);
    });
  }

  // Function to show historical data
  void showHistoricalData() {
    final historyData = context.read<SensorBloc>().sensorDataHistory;

    /// Display the history
    for (var data in historyData) {
      print('Luminosity: ${data.luminositySensorData.value} ${data.luminositySensorData.unit}');
      print('Temperature: ${data.temperatureSensorData.value} ${data.temperatureSensorData.unit}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorBloc, SensorState>(
      builder: (context, state) {
        final luminositySensorData = state.luminositySensorData;
        final temperatureSensorData = state.temperatureSensorData;

        return Container(
            padding: const EdgeInsets.all(12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sensors Data',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'update each 10 sec',
                      style: TextStyle(
                        color: Color(0xFF7E7E7E),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),

                /// Sensors details ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SingleSensor(
                      sensorData: temperatureSensorData,
                      icon: Icons.thermostat_outlined,
                      color: Color(0xFFFFE3E1),
                      label: 'Temperature',
                      coloricon: Color(0xFFFF3333),
                    ),
                    SizedBox(width: 24),
                    SingleSensor(
                      sensorData: luminositySensorData,
                      icon: Icons.wb_sunny_outlined,
                      color: Color(0xFFFFF4D4),
                      label: 'Luminosity',
                      coloricon: Color(0xFFFFC107),
                    ),
                  ],
                ),
              ],
            )
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
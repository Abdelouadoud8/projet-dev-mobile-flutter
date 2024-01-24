import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:projet_mobile/views/sensor_display.dart';

import './views/temperature_threshold.dart';
import './views/luminosity_threshold.dart';
import './views/threshold_box.dart';
import './model/sensor_data.dart';

import './http_util.dart';
import 'cubit/sensor_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => SensorBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/temperature_threshold': (context) => TemperatureThreshold(),
        '/luminosity_threshold': (context) => LuminosityThreshold(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLampOn = false;

  Future<void> sendToggleRequest(bool isLampOn) async {
    await HttpUtil.sendToggleRequest(context, isLampOn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mobile project"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Avatar & Greetings ///
            Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://scontent.falg1-2.fna.fbcdn.net/v/t39.30808-6/382242246_3562506713988872_6711977455142897039_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=tT1VC0ocIeEAX9-E2V9&_nc_zt=23&_nc_ht=scontent.falg1-2.fna&oh=00_AfDH_4X0sIDdJgES2U3j5AJVRKNVGl-1WeCxfhQA1McFQA&oe=65B3E034",                        // Replace with the actual image URL
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Home,',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4000000059604645),
                        fontSize: 18,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mahdaoui Abdelouadoud',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 22,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),


            /// Sensors values container
            SensorsBox(),
            SizedBox(height: 30),

            /// Manage Sensors values and states ///
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Section title ///
                Text(
                  'Manage Sensors',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 22,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),

                /// Toggle LED switch box ///
                Container(
                  padding: const EdgeInsets.all(12),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFCFCFC),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFFF0F2FF), // Replace with your desired background color
                            ),
                            padding: EdgeInsets.all(8), // Adjust the padding as needed
                            child: Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 28,
                              color: Color(0xFF0578FF), // You can adjust the icon color
                            ),
                          ),
                          SizedBox(height:8),
                          Text(
                            'Lamp',
                            style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      Switch(
                        value: isLampOn,
                        onChanged: (bool value) {
                          setState(() {
                            isLampOn = value;
                          });

                          // Send a POST request to the server
                          sendToggleRequest(isLampOn);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                /// Temp and Luminosity threshold boxes ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ThresholdBox(
                      label: "Temperature Threshold",
                      value: 22,
                      icon: Icons.thermostat_outlined,
                      onPressed: () {
                        Navigator.pushNamed(context, '/temperature_threshold');
                      },
                    ),
                    SizedBox(width: 16),
                    ThresholdBox(
                      label: "Luminosity Threshold",
                      value: 22,
                      icon: Icons.wb_sunny_outlined,
                      onPressed: () {
                        Navigator.pushNamed(context, '/luminosity_threshold');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}








/// COMPONENTS AND MODELS ///
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
                    SensorDisplay(
                      sensorData: temperatureSensorData,
                      icon: Icons.thermostat_outlined,
                      color: Color(0xFFFF3333),
                      label: 'Temperature',
                    ),
                    SizedBox(width: 24),
                    SensorDisplay(
                      sensorData: luminositySensorData,
                      icon: Icons.wb_sunny_outlined,
                      color: Color(0xFFFFC107),
                      label: 'Luminosity',
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
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }
}
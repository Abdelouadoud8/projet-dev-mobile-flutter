import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './views/temperature_threshold.dart';
import './views/luminosity_threshold.dart';
import './views/threshold_box.dart';
import './model/sensor_data.dart';

import './http_util.dart';

void main() {
  runApp(MyApp());
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
  SensorData luminositySensorData = SensorData(value: 0, unit: '°C');
  SensorData temperatureSensorData = SensorData(value: 0, unit: 'W');
  late Timer _timer; // Declare a Timer

  final Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'PostmanRuntime/7.28.4',
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
  };

  /// Lum and Temp separated ///
  /*Future<void> fetchLuminosityData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.254.197:2000/luminosity'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          luminositySensorData = SensorData.fromJson(data);
        });
      } else {
        throw Exception('Failed to load luminosity data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchTemperatureData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.254.197:2000/temperature'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          temperatureSensorData = SensorData.fromJson(data);
        });
      } else {
        throw Exception('Failed to load temperature data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  */

  /// Retrieve Lum and Temp together ///
  Future<void> fetchData() async {
    try {
      final luminosityResponse = await http.get(
        Uri.parse('http://192.168.254.197:2000/luminosity'),
        headers: headers,
      );

      final temperatureResponse = await http.get(
        Uri.parse('http://192.168.254.197:2000/temperature'),
        headers: headers,
      );

      if (luminosityResponse.statusCode == 200 || temperatureResponse.statusCode == 200) {
        final Map<String, dynamic> luminosityData = json.decode(luminosityResponse.body);
        final Map<String, dynamic> temperatureData = json.decode(temperatureResponse.body);

        setState(() {
          luminositySensorData = SensorData.fromJson(luminosityData);
          temperatureSensorData = SensorData.fromJson(temperatureData);
        });
      } else {
        throw Exception('Failed to load data. Luminosity Status Code: ${luminosityResponse.statusCode}, Temperature Status Code: ${temperatureResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
    // Fetch temperature data immediately when the widget is created

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
  }
}

/// Initiation of luminosity and temperature ///
SensorData luminositySensorData = SensorData(
  value: 23,
  unit: '°C',
);
SensorData temperatureSensorData = SensorData(
  value: 28,
  unit: 'W',
);

/// Single Sensor Structure
class SensorDisplay extends StatelessWidget {
  final SensorData sensorData;
  final String label;
  final IconData icon;
  final Color color;

  const SensorDisplay({
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
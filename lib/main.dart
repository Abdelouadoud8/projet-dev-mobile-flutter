import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_mobile/views/sensors_box.dart';
import 'package:projet_mobile/views/temp_lum_history.dart';

import './views/temperature_threshold.dart';
import './views/luminosity_threshold.dart';
import './views/threshold_box.dart';

import './http_util.dart';
import 'cubit/sensor_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import './services/firestore_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/history': (context) => TempLumHistory(),
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
    final FirebaseService _firebaseService = FirebaseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mobile project"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                    ),
                    SizedBox(width: 16),
                    ThresholdBox(
                      label: "History",
                      value: 22,
                      icon: Icons.insert_drive_file_outlined,
                      onPressed: () {
                        Navigator.pushNamed(context, '/history');
                      },
                    ),
                  ],
                ),
              ],
            ),

            /// TESTING ///
            /*Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // _firebaseService.addSensorData('WORKKKINNGGG, Firebase!');
                  },
                  child: Text('Add Data to Firestore'),
                ),
                StreamBuilder<QuerySnapshot<Object?>>(
                  stream: _firebaseService.getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final data = snapshot.data?.docs ?? []; // Use null-safe operator and provide a default value
                    return Column(
                      children: data.map((doc) {
                        final message = doc['message'] as String? ?? ''; // Cast to String and handle null
                        return Text(message);
                      }).toList(),
                    );
                  },
                )
              ],
            ),*/
          ],
        ),
      ),
    ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

import '../services/firestore_service.dart';

class TempLumHistory extends StatefulWidget {
  @override
  _TempLumHistoryState createState() => _TempLumHistoryState();
}

class _TempLumHistoryState extends State<TempLumHistory> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data Page'),
        centerTitle: true,
        backgroundColor: Color(0xFF8F42F1),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: StreamBuilder<QuerySnapshot>(
          stream: firebaseService.getData(),
          builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data?.docs;

          return ListView.builder(
            itemCount: documents?.length,
            itemBuilder: (context, index) {
              final document = documents![index];
              final temperature = document['temperature'];
              final luminosity = document['luminosity'];
              final timestamp = document['timestamp'] as Timestamp;
              final date = timestamp.toDate();
              final eightDaysAgo = date.subtract(Duration(days: 8));

              // Format the date to show only date + time (hours:minutes)
              final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(eightDaysAgo);

              return Column(
                children: [
                  SizedBox(height:16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$formattedDate',
                          style: TextStyle(
                            color: Color(0xFF474747),
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child:
                              Column(
                                children: [
                                  Icon(Icons.thermostat, size: 40, color: Color(0xFFFF3333)),
                                  SizedBox(height: 4),
                                  Text(
                                    'Temperature',
                                    style: TextStyle(
                                      color: Color(0xFF8D8D8D),
                                      fontSize: 18,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${temperature.toStringAsFixed(2)} °C",
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 22,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(Icons.wb_sunny_outlined, size: 40, color: Colors.orange),
                                  SizedBox(height: 4),
                                  Text(
                                    'Luminosity',
                                    style: TextStyle(
                                      color: Color(0xFF8D8D8D),
                                      fontSize: 18,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${luminosity.toStringAsFixed(2)} W",
                                    style: TextStyle(
                                      color: Color(0xFF262626),
                                      fontSize: 22,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );

            },
          );
        },
      ),
      ),
    );
  }
}
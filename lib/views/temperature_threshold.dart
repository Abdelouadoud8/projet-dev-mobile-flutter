import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TemperatureThreshold extends StatefulWidget {
  @override
  _TemperatureThresholdState createState() => _TemperatureThresholdState();
}

class _TemperatureThresholdState extends State<TemperatureThreshold> {
  final TextEditingController _thresholdController = TextEditingController();

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Temperature threshold saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $errorMessage'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _postSeuilTemp() async {
    final serverBaseUrl = "http://192.168.254.197:2000"; // Replace with your server URL
    final threshold = _thresholdController.text;

    try {
      final response = await http.post(
        Uri.parse('$serverBaseUrl/seuil_temp'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
        },
        body: {
          'seuil_temp': threshold,
        },
      );

      if (response.statusCode == 200) {
        // Successful response
        _showSuccessSnackBar();
        print('Temperature seuil saved successfully');
      } else {
        // Handle error here
        _showErrorSnackBar("Threshold has not been updated");
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network or other errors
      _showErrorSnackBar(e.toString());
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Threshold'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            // Image at the top
            Image.asset('images/termo.png'),
            SizedBox(height: 24), // Spacing between image and text
            // Main text title
            Text(
              'Change Luminosity Threshold',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),

            /// Input box and label ///
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Threshold',
                  style: TextStyle(
                    color: Color(0xFF4F4F4F),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFBDBDBD),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _thresholdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter a number',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            // Update button at the bottom
            ElevatedButton(
              onPressed: _postSeuilTemp,
              child: Text('Update Threshold'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projet_mobile/views/primary_button.dart';
import '../http_util.dart';

class LuminosityThreshold extends StatefulWidget {
  @override
  _LuminosityThresholdState createState() => _LuminosityThresholdState();
}

class _LuminosityThresholdState extends State<LuminosityThreshold> {
  final TextEditingController _thresholdController = TextEditingController();

  void _postSeuilLum() async {
    final threshold = _thresholdController.text;

    try {
      await HttpUtil.sendLuminosityThreshold(context, threshold);
      _thresholdController.clear();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luminosity Threshold'),
        centerTitle: true,
        backgroundColor: Color(0xFF8F42F1),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            // Image at the top
            Image.asset('images/lamp.png'),
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
            PrimaryButton(
              onPressed: _postSeuilLum,
            ),
          ],
        ),
      ),
    ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


final headers = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'User-Agent': 'PostmanRuntime/7.28.4',
  'Accept': '*/*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Connection': 'keep-alive',
};
final serverBaseUrl = "http://192.168.254.197:2000";

void _showSuccessSnackBar(BuildContext context,) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('LED toggled successfully'),
      backgroundColor: Colors.green,
    ),
  );
}

void _showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: $errorMessage'),
      backgroundColor: Colors.red,
    ),
  );
}


class HttpUtil {
  /// Toggle LED ///
  static Future<void> sendToggleRequest(BuildContext context, bool isLampOn) async {
    final toggleLedEndpoint = "/toggle_led";
    final body = {
      'isLampOn': isLampOn.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse(serverBaseUrl + toggleLedEndpoint),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("LED toggled successfully");
        _showSuccessSnackBar(context);
      } else {
        _showErrorSnackBar(context, "Failed to toggle LED.");
        print("Failed to toggle LED. Status code: ${response.statusCode}");
        // Handle the failure case here
      }
    } catch (error) {
      print("Error sending request: $error");
      // Handle any errors that occur during the request
    }
  }


}

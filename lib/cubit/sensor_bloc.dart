import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../http_util.dart';
import '../model/sensor_data.dart';
import '../services/firestore_service.dart';

enum SensorEvent { fetch }

class SensorState {
  final SensorData luminositySensorData;
  final SensorData temperatureSensorData;

  SensorState({
    required this.luminositySensorData,
    required this.temperatureSensorData,
  });

  factory SensorState.initial() {
    return SensorState(
      luminositySensorData: SensorData(value: 0, unit: '°C'),
      temperatureSensorData: SensorData(value: 0, unit: 'W'),
    );
  }
}

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  List<SensorState> sensorDataHistory = [];

  SensorBloc() : super(SensorState.initial());

  @override
  Stream<SensorState> mapEventToState(SensorEvent event) async* {
    if (event == SensorEvent.fetch) {
      try {
        final luminosityResponse = await http.get(
          Uri.parse('http://192.168.254.197:2000/luminosity'),
          headers: headers,
        );

        final temperatureResponse = await http.get(
          Uri.parse('http://192.168.254.197:2000/temperature'),
          headers: headers,
        );

        if (luminosityResponse.statusCode == 200 ||
            temperatureResponse.statusCode == 200) {
          final Map<String, dynamic> luminosityData =
          json.decode(luminosityResponse.body);
          final Map<String, dynamic> temperatureData =
          json.decode(temperatureResponse.body);

          final luminositySensorData = SensorData(
            value: luminosityData['value'],
            unit: luminosityData['unit'],
          );
          final temperatureSensorData = SensorData(
            value: temperatureData['value'],
            unit: temperatureData['unit'],
          );

          yield SensorState(
            luminositySensorData: luminositySensorData,
            temperatureSensorData: temperatureSensorData,
          );

          FirebaseService().addSensorData(
            temperatureSensorData.value,
            luminositySensorData.value,
          );

          sensorDataHistory.add(SensorState(
            luminositySensorData: luminositySensorData,
            temperatureSensorData: temperatureSensorData,
          ));
        } else {
          throw Exception(
              'Failed to load data. Luminosity Status Code: ${luminosityResponse.statusCode}, Temperature Status Code: ${temperatureResponse.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }


}

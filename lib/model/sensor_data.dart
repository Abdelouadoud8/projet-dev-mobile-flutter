class SensorData {
  double value;
  String unit;

  SensorData({required this.value, required this.unit});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(value: json['value'] as double, unit: json['unit']);
  }
}
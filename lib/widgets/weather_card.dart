import 'package:flutter/material.dart';
class WeatherCard extends StatelessWidget {
  final String city;
  final Map<String, dynamic>? weatherData;

  const WeatherCard({required this.city, required this.weatherData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text('Loading $city...')),
        ),
      );
    }

    final condition = weatherData!['current_condition'][0];
    final temp = condition['temp_C'];
    final desc = condition['weatherDesc'][0]['value'];
    final humidity = condition['humidity'];
    final wind = condition['windspeedKmph'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(city,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 8),
            Text(desc,
                style: TextStyle(color: Colors.indigo, fontSize: 16),
                textAlign: TextAlign.center),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🌡 $temp°C', style: TextStyle(fontSize: 16)),
                SizedBox(width: 16),
                Text('💧 $humidity%', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),
            Text('💨 $wind km/h', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
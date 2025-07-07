import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherDetailScreen extends StatefulWidget {
  final String cityName;
  const WeatherDetailScreen({required this.cityName, Key? key}) : super(key: key);

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  Map<String, dynamic>? _weatherData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final data = await WeatherService.fetchWeather(widget.cityName);
    if (mounted) {
      setState(() {
        _weatherData = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in ${widget.cityName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _weatherData == null
          ? Center(child: Text('No data found for ${widget.cityName}'))
          : Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cityName,
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _weatherData!['current_condition'][0]
                      ['weatherDesc'][0]['value'],
                      style: TextStyle(
                          fontSize: 22, color: Colors.indigo),
                    ),
                    SizedBox(height: 24),
                    _buildWeatherInfoRow(
                        '🌡', 'Temperature', '${_weatherData!['current_condition'][0]['temp_C']}°C'),
                    _buildWeatherInfoRow('💧', 'Humidity',
                        '${_weatherData!['current_condition'][0]['humidity']}%'),
                    _buildWeatherInfoRow('💨', 'Wind Speed',
                        '${_weatherData!['current_condition'][0]['windspeedKmph']} km/h'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfoRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 18)),
          Spacer(),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
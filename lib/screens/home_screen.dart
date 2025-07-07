import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import 'weather_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> cities = ['London', 'Manchester', 'Bristol', 'Edinburgh'];
  Map<String, dynamic> weatherData = {};
  bool isLoading = true;

  final TextEditingController _controller = TextEditingController();
  String _cityName = '';

  @override
  void initState() {
    super.initState();
    _fetchAllWeather();
  }

  Future<void> _fetchAllWeather() async {
    setState(() => isLoading = true);
    Map<String, dynamic> tempData = {};
    for (final city in cities) {
      final data = await WeatherService.fetchWeather(city);
      if (data != null) tempData[city] = data;
    }
    setState(() {
      weatherData = tempData;
      isLoading = false;
    });
  }

  void _onSearchPressed() {
    final city = _cityName.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a city name'))
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WeatherDetailScreen(cityName: city)),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🌤 Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Search for a city...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.indigo),
                        ),
                        onChanged: (val) => setState(() => _cityName = val),
                        onSubmitted: (_) => _onSearchPressed(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.indigo),
                      onPressed: _onSearchPressed,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final cityWeather = weatherData[city];
                      if (cityWeather == null) {
                        return Card(
                          child: Center(child: Text('No data for $city')),
                        );
                      }
                      return WeatherCard(city: city, weatherData: cityWeather);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
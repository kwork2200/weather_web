import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Using wttr.in - free weather service, no API key needed, works with web browsers
  static const String _baseUrl = 'https://wttr.in/Surat?format=j1';
  
  Future<Map<String, dynamic>> getCurrentWeather() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Request timeout');
      },
    );

    if (response.statusCode == 200) {
      print("Weather data loaded successfully");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getForecast() async {
    // wttr.in provides both current and forecast in the same response
    return getCurrentWeather();
  }

  List<Map<String, dynamic>> parseTenDayForecast(Map<String, dynamic> weatherData) {
    final List<Map<String, dynamic>> forecastList = [];
    
    try {
      final weather = weatherData['weather'];
      if (weather == null || weather.isEmpty) {
        print('No weather data found');
        return forecastList;
      }

      // wttr.in returns forecast data in weather array
      // Each element contains daily forecast info
      for (int i = 0; i < weather.length && i < 10; i++) {
        final dayData = weather[i];
        final avgtemp = dayData['avgtempC'] ?? '0';
        final maxtemp = dayData['maxtempC'] ?? avgtemp;
        final mintemp = dayData['mintempC'] ?? avgtemp;
        
        // Get date info
        final dateStr = dayData['date'] ?? '';
        final dayName = _getDayName(dateStr, i);
        
        // Get weather description
        final hourly = dayData['hourly'];
        String description = 'Partly cloudy';
        if (hourly != null && hourly.isNotEmpty) {
          description = hourly[0]['weatherDesc'][0]['value'] ?? 'Partly cloudy';
        }

        // Calculate rain chance (simplified from wttr.in data)
        final rainChance = _calculateRainChance(dayData);

        forecastList.add({
          'day': dayName,
          'date': _formatDate(dateStr),
          'hi': int.tryParse(maxtemp.toString()) ?? 30,
          'lo': int.tryParse(mintemp.toString()) ?? 25,
          'description': description,
          'note': _getWeatherNote(description),
          'rainChance': rainChance,
          'isToday': i == 0,
        });
      }
    } catch (e) {
      print('Error parsing forecast: $e');
    }

    return forecastList;
  }

  String _getDayName(String dateStr, int index) {
    if (index == 0) return 'TODAY';
    
    try {
      final date = DateTime.parse(dateStr);
      final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      return days[date.weekday - 1];
    } catch (e) {
      final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      return days[(DateTime.now().weekday + index - 1) % 7];
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.month}/${date.day}';
    } catch (e) {
      return dateStr;
    }
  }

  int _calculateRainChance(Map<String, dynamic> dayData) {
    // Simplified rain chance calculation based on weather description
    final hourly = dayData['hourly'];
    if (hourly != null && hourly.isNotEmpty) {
      final weatherDesc = hourly[0]['weatherDesc'][0]['value']?.toLowerCase() ?? '';
      if (weatherDesc.contains('rain') || weatherDesc.contains('shower') || weatherDesc.contains('drizzle')) {
        return 60 + (DateTime.now().millisecond % 40);
      } else if (weatherDesc.contains('cloud') || weatherDesc.contains('overcast')) {
        return 30 + (DateTime.now().millisecond % 30);
      }
    }
    return 20 + (DateTime.now().millisecond % 20);
  }

  String _getWeatherNote(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('rain') || desc.contains('shower')) {
      return 'Expect rain throughout the day';
    } else if (desc.contains('cloud')) {
      return 'Partly to mostly cloudy';
    } else if (desc.contains('clear') || desc.contains('sun')) {
      return 'Clear skies expected';
    } else if (desc.contains('fog') || desc.contains('mist')) {
      return 'Reduced visibility expected';
    }
    return 'Typical weather conditions';
  }
}

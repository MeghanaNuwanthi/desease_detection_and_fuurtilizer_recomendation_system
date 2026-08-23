// lib/services/weather_service.dart

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperatureCelsius;
  final int humidityPercent;
  final String locationLabel;
  final String conditionDescription;

  WeatherData({
    required this.temperatureCelsius,
    required this.humidityPercent,
    required this.locationLabel,
    required this.conditionDescription,
  });
}

class WeatherService {
  WeatherService._internal();
  static final WeatherService instance = WeatherService._internal();

  Future<WeatherData> getCurrentWeather() async {
    final position = await _getCurrentPosition();

    final uri = Uri.parse(
      "https://api.open-meteo.com/v1/forecast"
      "?latitude=${position.latitude}"
      "&longitude=${position.longitude}"
      "&current=temperature_2m,relative_humidity_2m,weather_code",
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception("Weather API returned ${response.statusCode}");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data["current"] as Map<String, dynamic>;

    final locationLabel = await _reverseGeocode(
      position.latitude,
      position.longitude,
    );

    return WeatherData(
      temperatureCelsius: (current["temperature_2m"] as num).toDouble(),
      humidityPercent: (current["relative_humidity_2m"] as num).toInt(),
      locationLabel: locationLabel,
      conditionDescription: _describeWeatherCode(
        current["weather_code"] as int,
      ),
    );
  }

  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled on this device.");
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location permission permanently denied - enable it in device settings.",
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low, // low is plenty for a weather card
    );
  }

  /// Uses Open-Meteo's free reverse geocoding to turn coordinates into a
  /// readable place name. Falls back to raw coordinates if it fails - never
  /// let a display-only label crash the weather card.
  Future<String> _reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/reverse"
        "?latitude=$lat&longitude=$lon&count=1",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data["results"] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final place = results[0] as Map<String, dynamic>;
          return place["name"] as String? ?? "Your location";
        }
      }
    } catch (_) {
      // fall through to the coordinate fallback below
    }
    return "${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)}";
  }

  /// Open-Meteo returns WMO weather codes (numbers), not text - this maps
  /// the common ones to a short description. Not exhaustive, covers the
  /// typical Sri Lankan weather patterns.
  String _describeWeatherCode(int code) {
    if (code == 0) return "Clear sky";
    if (code <= 3) return "Partly cloudy";
    if (code <= 48) return "Foggy";
    if (code <= 57) return "Drizzle";
    if (code <= 67) return "Rainy";
    if (code <= 77)
      return "Snow"; // unlikely in Sri Lanka, included for completeness
    if (code <= 82) return "Rain showers";
    if (code <= 99) return "Thunderstorm";
    return "Unknown";
  }
}

import 'dart:convert';
import 'package:berlin_travel_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherApi {
  static const String weatherApiUrl =
      "https://api.open-meteo.com/v1/forecast?latitude=52.31&longitude=13.24&hourly=temperature_2m&forecast_days=1";
  static const String timeApiUrl =
      "http://worldtimeapi.org/api/timezone/Europe/Berlin";

  static Future<void> getWeatherData() async {
    final timeResponse = await http.get(Uri.parse(timeApiUrl));
    final timeData = jsonDecode(timeResponse.body);
    String currentTime = timeData['datetime'];

    DateTime berlinTimeDateTime = DateTime.parse(currentTime);

    String formattedBerlinTime = DateFormat('HH:mm').format(berlinTimeDateTime);

    final weatherResponse = await http.get(Uri.parse(weatherApiUrl));
    final weatherData = jsonDecode(weatherResponse.body);
    List<dynamic> temperatures = weatherData['hourly']['temperature_2m'];

    double totalTemperature =
        temperatures.fold(0.0, (prev, element) => prev + element);
    double averageTemperature = totalTemperature / temperatures.length;

    temperature = averageTemperature;
    berlinTime = formattedBerlinTime;
  }
}

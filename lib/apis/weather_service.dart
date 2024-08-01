import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_forecast_app/model/weather_model.dart';

class WeatherService {
  static const String apiKey = '9261e52554136d24022d40cb4580f640';

  Future<WeatherModel?> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<WeatherModel>?> getForecast(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['list'];
      return data.map((json) => WeatherModel.fromJson(json)).toList();
    } else {
      return null;
    }
  }
}

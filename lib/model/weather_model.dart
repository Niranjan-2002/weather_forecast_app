class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final String date;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.date,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['description'],
      date: json['dt_txt'] ?? '',
    );
  }
}

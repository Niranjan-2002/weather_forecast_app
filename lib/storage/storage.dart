import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:weather_forecast_app/model/weather_model.dart';


class StorageUtil {
  static Future<void> initHive() async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(WeatherModelAdapter());
  }

  static Future<void> saveWeatherData(String city, WeatherModel currentWeather, List<WeatherModel> forecast) async {
    final box = await Hive.openBox(city);
    await box.put('currentWeather', currentWeather);
    await box.put('forecast', forecast);
  }

  static Future<Map<String, dynamic>?> getWeatherData(String city) async {
    final box = await Hive.openBox(city);
    if (box.isEmpty) {
      return null;
    }
    return {
      'currentWeather': box.get('currentWeather'),
      'forecast': box.get('forecast'),
    };
  }
}

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final typeId = 0;

  @override
  WeatherModel read(BinaryReader reader) {
    return WeatherModel(
      cityName: reader.read(),
      temperature: reader.read(),
      condition: reader.read(),
      date: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer.write(obj.cityName);
    writer.write(obj.temperature);
    writer.write(obj.condition);
    writer.write(obj.date);
  }
}

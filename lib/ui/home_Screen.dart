import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast_app/apis/weather_service.dart';
import 'package:weather_forecast_app/model/weather_model.dart';

import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel? currentWeather;
  List<WeatherModel>? forecast;
  String? selectedCity;
  
  @override
  void initState() {
    super.initState();
    _loadCity();
  }

  _loadCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? city = prefs.getString('selectedCity');
    if (city != null) {
      setState(() {
        selectedCity = city;
      });
      _fetchWeather(city);
    }
  }

  _fetchWeather(String city) async {
    WeatherService weatherService = WeatherService();
    WeatherModel? current = await weatherService.getCurrentWeather(city);
    List<WeatherModel>? forecastData = await weatherService.getForecast(city);
    setState(() {
      currentWeather = current;
      forecast = forecastData;
    });
  }

  _onSearchPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('selectedCity', result);
      setState(() {
        selectedCity = result;
      });
      _fetchWeather(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        actions: [
          IconButton(
            icon:const Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentWeather != null)
              CurrentWeatherWidget(weather: currentWeather!),
           const   SizedBox(
                height: 30,
              ),
            if (forecast != null)
              Expanded(
                child: ListView.builder(
                  itemCount: forecast!.length,
                  itemBuilder: (context, index) {
                    return ForecastWidget(weather: forecast![index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  CurrentWeatherWidget({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
   
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:const Color.fromARGB(255, 170, 156, 150)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                   const Text('Current Weather in',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            
                    const SizedBox(
                      height: 5,
                    ),
            
                    Text( '${weather.cityName}',
                      style:const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
         const  SizedBox(height: 8),     

          Row(
           children: [
             Expanded(
              flex: 1,
               child: Container(
                //height: 25,
                // width: 12,
                
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color:  Color.fromARGB(255, 180, 249, 249),
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                     const Text('Temperature:'),
                    const   FaIcon(FontAwesomeIcons.cloudSun),
             
                      Text('${weather.temperature}°C'),
                
                    ],
                  ),
                ),
               ),
             ),
             const  SizedBox(
                width: 8,
              ),
               Expanded(
               // flex: 1,
                 child: Container(
                             //height: 25,
                              width: double.infinity,
                             
                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                             color: Color.fromARGB(255, 180, 249, 249),
                             ),
                             child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                     const Text('Condition:'),
                     const Icon(Icons.cloud_circle),
                      Text(weather.condition),
                             
                    ],
                  ),
                             ),
                            ),
               ),
           
           ],
         ),     
        ],

      
    );
  }
}

class ForecastWidget extends StatelessWidget {
  final WeatherModel weather;

  ForecastWidget({required this.weather});

  @override
  Widget build(BuildContext context) {
    return ListTile(
  title: Expanded(
    child: Card(
      color: Color.fromARGB(255, 160, 182, 219),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children:  [
               const Text('Date:'),
               const Spacer(),
                Text(weather.date),
              ],
            ),
           const SizedBox(
              height: 10,
            ),
            Row(
              children: [
               const Text('temperature:'),
                 const Spacer(),
                Text('${weather.temperature}°C')
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
               const Text('condition:'),
                 const Spacer(),
                Text(weather.condition)
              ],
            ),
            
          ],
        ),
      ),
    ),
  ),
);

  }
}

import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const apiKey = 'b40dffa8d18c78216ee09df41c5edf16';
const openAreaUrl = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {

  LatLong latLong;

  Future<dynamic> getLocationWeather() async{
    latLong = await Location.getLocation();
    NetworkHelper networkHelper = NetworkHelper('$openAreaUrl?lat=${latLong.latitude}&lon=${latLong.longitude}&units=metric&appid=$apiKey');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getCityWeather(String cityName) async{
    NetworkHelper networkHelper = NetworkHelper('$openAreaUrl?q=$cityName&units=metric&appid=$apiKey');
    var weatherData = await networkHelper.getData();
    print(weatherData);
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

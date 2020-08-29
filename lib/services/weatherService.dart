import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:thelauncher/models/weatherModel.dart';

class WeatherService {
  static const String API_KEY = "bd8b93dcc83fb3841707f9a660a0b03b";
  WeatherModel weatherModel;

  Future<bool> getWeather() async {
    if (await Permission.location.request().isGranted) {
      Position location = await Geolocator().getCurrentPosition();
      String url =
          "https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$API_KEY";

      http.Response response = await http.get(url);

      Map<String, dynamic> data = json.decode(response.body);

      print(data.toString());

      final model = WeatherModel(
        iconUrl:
            "http://openweathermap.org/img/wn/${data["weather"].first["icon"]}@4x.png",
        degrees: data["main"]["temp"],
        tempMax: data["main"]["temp_max"],
        tempMin: data["main"]["temp_min"],
        humidity: data["main"]["humidity"],
        feelsLike: data["main"]["feels_like"],
      );

      if (model.isEqualTo(other: weatherModel)) {
        return false;
      }

      weatherModel = model;

      return true;
    }
    return false;
  }
}

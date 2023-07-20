import 'package:flutter/cupertino.dart';
import 'package:weather_app/services/networking.dart';

class Weather {
  static final apiKey = '&units=metric&appid=a43ef9cf99ed05a19a6715a3a1ac1e85';
  static final apiURL = 'https://api.openweathermap.org/data/2.5/';

  Future getLocationWeatherCurrentData(
      {required double longitude, required double latitude}) async {
    NetworkHelper networkHelper = new NetworkHelper(
        url: '${apiURL}weather?lat=$latitude&lon=$longitude$apiKey');
    return await networkHelper.getResponseData();
  }

  Future getCityWeatherCurrentData({required String cityName}) async {
    NetworkHelper networkHelper =
        new NetworkHelper(url: '${apiURL}weather?q=$cityName$apiKey');
    return await networkHelper.getResponseData();
  }

  Future getCityWeatherForecastData({required String cityName}) async {
    NetworkHelper networkHelper =
        new NetworkHelper(url: '${apiURL}forecast?q=$cityName$apiKey');
    return await networkHelper.getResponseData();
  }
}

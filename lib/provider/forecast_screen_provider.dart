import 'package:flutter/material.dart';
import 'package:weather_app/services/networking.dart';
import 'package:weather_app/services/weather.dart';

class ForecastScreenProvider extends ChangeNotifier{


  bool _isLoading = false;
  bool get isloading =>_isLoading;
  NetworkHelper? _networkHelper;
  NetworkHelper? get networkHelper => _networkHelper;


  Future getCityWeatherForecastData({required String cityName}) async {
    _isLoading = true;
    notifyListeners();
    new NetworkHelper(url: '${Weather.apiURL}forecast?q=$cityName${Weather.apiKey}');
    _isLoading = false;
    _networkHelper = await _networkHelper!.getResponseData();
    notifyListeners();

  }
}
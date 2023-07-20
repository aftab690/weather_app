import 'package:flutter/material.dart';
import 'package:weather_app/services/formatted_date_time.dart';
import 'package:weather_app/utilities/constants.dart';

class LocationScreenProvider extends ChangeNotifier{

  int? _currentCityId;
  int? get currentCityId => _currentCityId;

  String? _currentDateTime;
  String? get currentDateTime => _currentDateTime;

  IconData? _weatherIcon;
  IconData? get weatherIcon => _weatherIcon;

  String? _weatherIconId;
  String? get weatherIconId => _weatherIconId;

  String? _weatherStatus;
  String? get weatherStatus => _weatherStatus;

  String? _cityName;
  String? get cityName => _cityName;

  double? _temperature;
  double? get temperature =>_temperature;

  double? _temperatureFeelLike;
  double? get temperatureFeelLike =>_temperatureFeelLike;

  double? _wind;
  double? get wind =>_wind;

  int? _humidity;
  int? get humidity => _humidity;

  int? _pressure;
  int? get pressure => _pressure;

  int? _visibility;
  int? get visibility => _visibility;

  int? _cloudiness;
  int? get cloudiness => _cloudiness;

  bool? _celsiusButtonStatus;
  bool? get celsiusButtonStatus =>_celsiusButtonStatus;

  bool? _fahrenheitButtonStatus;
  bool? get fahrenheitButtonStatus =>_fahrenheitButtonStatus;

  Color? _celsiusButtonColor;
  Color? get celsiusButtonColor => _celsiusButtonColor;

  Color? _fahrenheitButtonColor;
  Color? get fahrenheitButtonColor => _fahrenheitButtonColor;

  double? _celsiusButtonElevation;
  double? get celsiusButtonElevation =>_celsiusButtonElevation;

  double? _fahrenheitButtonElevation;
  double? get fahrenheitButtonElevation =>_fahrenheitButtonElevation;

  BoxDecoration? _boxDecoration;
  BoxDecoration? get boxDecoration => _boxDecoration;

  List<Color>? _gradientBackgroundColor;
  List<Color>? get gradientBackgroundColor => _gradientBackgroundColor;

  bool _pressAttention = true;
  bool get pressAttention => _pressAttention;


  void updateUI(dynamic weatherData) {

        _currentCityId = weatherData['weather'][0]['id'];
        _weatherIconId = weatherData['weather'][0]['icon'];
        _weatherStatus = weatherData['weather'][0]['main'];
        _cityName = weatherData['name'];
        _temperature = weatherData['main']['temp'].toDouble();
        _temperatureFeelLike = weatherData['main']['feels_like'].toDouble();
        _wind = weatherData['wind']['speed'].toDouble();
        _humidity = weatherData['main']['humidity'];
        _pressure = weatherData['main']['pressure'];
        _visibility = weatherData['visibility'];
        _cloudiness = weatherData['clouds']['all'];
        _celsiusButtonStatus = true;
        _celsiusButtonColor = kEnabledButtonColor;
        _celsiusButtonElevation = kEnabledButtonElevation;
        _fahrenheitButtonStatus = false;
        _fahrenheitButtonColor = kDisabledButtonColor;
        _fahrenheitButtonElevation = kDisabledButtonElevation;
        _gradientBackgroundColor = kGradientBackground(
            cityID: _currentCityId!,
            currentTemperature: _temperature!,
            cityIconID: _weatherIconId!);
        _boxDecoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _gradientBackgroundColor!,
          ),
        );
      notifyListeners();
  }


  void getCurrentDateTimeString() {
    String timeString = FormattedDateTime(dateTime: DateTime.now())
        .getDeviceLocationFormattedDateTime();
      _currentDateTime = timeString;
      notifyListeners();

  }

  void setPressAttention() {
    _pressAttention = !_pressAttention;
    notifyListeners();
  }
}
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/location_screen_provider.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/screens/forecast_screen.dart';
import 'package:weather_app/services/location_info.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:weather_app/widgets/detail_card_widget.dart';
// Todo: refactor all code

class LocationScreen extends StatefulWidget {
  final weatherData;
  LocationScreen({@required this.weatherData});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<LocationScreenProvider>(context, listen: false).getCurrentDateTimeString();
    Timer.periodic(
        Duration(seconds: 1), (Timer t) => Provider.of<LocationScreenProvider>(context, listen: false).getCurrentDateTimeString());

    Provider.of<LocationScreenProvider>(context, listen: false).updateUI(widget.weatherData);
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new ElevatedButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }


  void _getUserLocationWeatherData() async {
    //Checking Internet Connection
    if (await kInternetConnectivityChecker() == true) {
      // getting user location
      if (await LocationInfo().getUserLocationAndGPS()) {
        LocationInfo locationInfo = new LocationInfo();
        await locationInfo.getUserLocationData();
        //getting weather data on basis of location
        Weather weather = new Weather();
        dynamic weatherData = await weather.getLocationWeatherCurrentData(
            longitude: locationInfo.longitude!, latitude: locationInfo.latitude!);
        Provider.of<LocationScreenProvider>(context, listen: false).updateUI(weatherData);
      }
    } else {
      _noInternetConnectionPopup();
    }
  }

  void _getForecastData() async {
    if (Provider.of<LocationScreenProvider>(context, listen: false).cityName == '') {
      _cityNotFoundPopUp();
    } else {
      if (await kInternetConnectivityChecker() == true) {
        Provider.of<LocationScreenProvider>(context, listen: false).setPressAttention();
        Weather weather = new Weather();
        dynamic weatherData =
            await weather.getCityWeatherForecastData(cityName: Provider.of<LocationScreenProvider>(context, listen: false).cityName!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ForecastScreen(
                gradientBackgroundColor: Provider.of<LocationScreenProvider>(context, listen: false).gradientBackgroundColor!,
                weatherData: weatherData,
              );
            },
          ),
        );
        Provider.of<LocationScreenProvider>(context, listen: false).setPressAttention();
      } else {
        _noInternetConnectionPopup();
      }
    }
  }


  void _cityNotFoundPopUp() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Error 404'),
        content: new Text('City Not Found'),
        actions: <Widget>[
          new ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('OK'),
          ),
        ],
      ),
    );
  }

  void _noInternetConnectionPopup() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(' No Internet '),
        content: new Text(
            'This app requires Internet connection. Do you want to continue?'),
        actions: <Widget>[
          new ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: new Text('cancel'),
          ),
          new ElevatedButton(
            onPressed: () async {
              if (await kInternetConnectivityChecker() == false) {
                OpenSettings.openWIFISetting();
              }
              Navigator.pop(context);
            },
            child: new Text('ok'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _loadData(context, false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Consumer<LocationScreenProvider>(
          builder: (context, locationScreenProvider, child) =>
              Container(
            decoration: locationScreenProvider.boxDecoration ?? null,
            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.gps_fixed),
                                color: Colors.white,
                                iconSize: 33,
                                onPressed: _getUserLocationWeatherData,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Text(
                                  locationScreenProvider.cityName!,
                                  style: TextStyle(fontSize: 23),
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                  ),
                                  iconSize: 33,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return CityScreen(
                                          gradientBackgroundColor:
                                          locationScreenProvider.gradientBackgroundColor!,
                                        );
                                      }),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            locationScreenProvider.currentDateTime!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              locationScreenProvider.weatherIcon,
                              size: 40.0,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              locationScreenProvider.weatherStatus!,
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${locationScreenProvider.temperature != null ? locationScreenProvider.temperature!.toInt() : locationScreenProvider.temperature}',
                              style: TextStyle(
                                fontSize: 70,
                              ),
                            ),
                            Text(" \u2103"),
                          ],
                        ),
                      ],
                    ),
                  ),
                 /* Container(
                    width: MediaQuery.of(context).copyWith().size.width / 3,
                    child: ElevatedButton(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: locationScreenProvider.pressAttention
                                ? <Widget>[
                                    // Icon(FontAwesome.line_chart),
                                    Text('Forecast'),
                                  ]
                                : <Widget>[
                                    SpinKitWave(
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                  ],
                          ),
                        ),
                        onPressed: _getForecastData),
                  ),*/
                  Container(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('DETAILS    '),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: DetailCardWidget(
                                cardIconData: null,
                                cardText: 'Feels like',
                                cardValue:
                                    '${locationScreenProvider.temperatureFeelLike != null ? locationScreenProvider.temperatureFeelLike!.toInt() : locationScreenProvider.temperatureFeelLike} °',
                              ),
                            ),
                            Expanded(
                              child: DetailCardWidget(
                                cardIconData: null,
                                cardText: 'Wind',
                                cardValue: locationScreenProvider.wind.toString()+'Km/h',
                              ),
                            ),
                            Expanded(
                              child: DetailCardWidget(
                                cardIconData: null,
                                cardText: 'Humidity',
                                cardValue: locationScreenProvider.humidity.toString()+ '%',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: DetailCardWidget(
                                cardIconData: null,
                                cardText: 'Pressure',
                                cardValue: locationScreenProvider.pressure.toString() + 'in',
                              ),
                            ),
                            Expanded(
                              child: DetailCardWidget(
                                cardIconData: null,
                                cardText: 'Visibility',
                                cardValue: locationScreenProvider.visibility.toString(),
                              ),
                            ),
                            Expanded(
                              child: DetailCardWidget(
                                cardIconData: null,
                                cardText: 'Clouds',
                                cardValue: locationScreenProvider.cloudiness.toString()+ '%',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

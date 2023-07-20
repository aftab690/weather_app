import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/forecast_screen_provider.dart';
import 'package:weather_app/provider/location_screen_provider.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/screens/loading_screen.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationScreenProvider>(create: (_) => LocationScreenProvider(),),
        ChangeNotifierProvider<ForecastScreenProvider>(create: (_) => ForecastScreenProvider(),),
      ],
      child:  MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Forcing Portrait orientation in device for App
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      routes: {
        '/CityScreen': (context) => CityScreen(),
      },
      home: LoadingScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/forcast_model.dart';

//Todo: add an exception that when Error is in  Location Screen
//Todo:  don't make weather data parameter as compulsory as empty data can be passed on error
//Todo: also get city name and check if city name is null and call API also
class ForecastScreen extends StatefulWidget {
  final List<Color> gradientBackgroundColor;
  final dynamic weatherData;
  ForecastScreen(
      {required this.gradientBackgroundColor, required this.weatherData});
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {

  final items = [0, 8, 16, 24, 32];
  dynamic weatherDataItems;
  List<ForecastModel?> forecastModelList = [];

  @override
  void initState() {
    // TODO: implement initState
    for (var i in items)
    forecastModelList.add(ForecastModel(date: DateFormat("yyyy-MM-dd").parse(widget.weatherData['list'][i]['dt_txt']), temperature: widget.weatherData['list'][i]['main']['temp'].toInt()));
    setState(() {

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.gradientBackgroundColor,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              height: 130,
              child: ListView.builder(
                itemCount: forecastModelList.length,
                itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Text(DateFormat.E().format(forecastModelList[index]!.date!)),
                            Text(forecastModelList[index]!.temperature.toString()),
                          ],
                        ),
                    ],
                  ),
                );
              },),
            ),
          )
        ),
      ),
    );
  }
}


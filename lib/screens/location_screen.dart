import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(this.locationWeather);

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temp;
  String condition;
  String cityName;
  String message;
  WeatherModel model = WeatherModel();

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  Alert errorDialog() {
    return new Alert(
        context: (context),
        title: "Error",
        desc: 'Unable to get weather data',
        style: AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white),
        ),
        buttons: [
          DialogButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        errorDialog().show();
      }
      print(weatherData);
      double localTemp = weatherData['main']['temp'];
      var conditionAux = weatherData['weather'][0]['id'];
      temp = localTemp.toInt();
      message = model.getMessage(temp);
      condition = model.getWeatherIcon(conditionAux);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await model.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var returnedName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      if (returnedName != null) {
                        var weatherData =
                            await model.getCityWeather(returnedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°C',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$condition',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

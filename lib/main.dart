import 'package:flutter/material.dart';
import 'package:weather_app_v2/weather_home_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherHomePage(),
      title: "Weather App",
      theme: ThemeData.dark(useMaterial3: true),
    );
  }


}
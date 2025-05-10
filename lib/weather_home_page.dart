import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app_v2/additional_info.dart';
import 'package:weather_app_v2/hourly_weather_status.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2/wrong_city.dart';
import 'package:weather_icons/weather_icons.dart';


class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {

  String? city;
  final _controller = TextEditingController();

  void searchIt() async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=${_controller.text}&units=metric&APPID=d0e02ccfbfe9353e8d360169dc519e6c'));
                      final responseData = jsonDecode(response.body);
                      setState(() {
                        if (responseData['message'].toString() != 'city not found'){
                          city = _controller.text;
                        }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return WrongCity();
                        }));
                        }
                      });
  }

  Future<Map<String,dynamic>> getWeather() async{
    try{
      final res = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&APPID=d0e02ccfbfe9353e8d360169dc519e6c"));
    final data = jsonDecode(res.body);
    return data;
    } catch (e){
      throw e.toString();
    }
  }

  Icon getWeatherIcon(String weatherstatus){
    if (weatherstatus == "Clouds"){
      return Icon(Icons.cloud,size: 70);
    }
    if (weatherstatus == "Rain"){
      return Icon(WeatherIcons.rain,size: 70);
    }
    return Icon(Icons.sunny,size: 70);      

  }

  Icon getWeatherIconHourly(String weatherstatus){
    if (weatherstatus == "Clouds"){
      return Icon(Icons.cloud,size: 40);
    }
    if (weatherstatus == "Rain"){
      return Icon(WeatherIcons.rain,size: 40);
    }
    return Icon(Icons.sunny,size: 40);      

  }

  Future<void> getUserCity() async{
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted){
      Position userPos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high
        )
      );
      List<Placemark> placeMark = await placemarkFromCoordinates(userPos.latitude, userPos.longitude);
      if (placeMark.isNotEmpty){
        final userCity = placeMark[0].locality;
        if (userCity != null){
          city = userCity;
        }
      }
    }else{
      print("permission not granted");
    }
  }

  @override
  void initState() {
   super.initState();
    initLocationAndLoad();
  }

  Future<void> initLocationAndLoad() async{
    await getUserCity();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    print(city);
    return city == null? Scaffold(body: Center(child: Text('Enable the Location Permission',style: TextStyle(fontSize: 20),)),) :
    Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: (){
              setState(() {
                
              });
            }, 
            child: Icon(
              Icons.refresh
            )
            )
        ],
        backgroundColor: const Color.fromARGB(255, 14, 13, 13),
        centerTitle: true,
        title: Text(
          "Weather App",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500
          ),
          ),
      ),
      body: city == null ? Center(child: CircularProgressIndicator.adaptive()) :
      FutureBuilder(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError){
            return Text(
              snapshot.error.toString()
            );
          }

          final data = snapshot.data!;
          final currentTemprature = data["list"][0]["main"]["temp"];
          final currentWeatherStatus = data["list"][0]["weather"][0]["main"];
          final currentHumidity = data["list"][0]["main"]["humidity"];
          final currentPressure = data["list"][0]["main"]["pressure"];
          final windSpeed = data["list"][0]["wind"]["speed"];
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    onSubmitted: (value){
                      searchIt();
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          searchIt();
                        }, 
                        icon: Icon(Icons.send)),
                      hintText: 'Search location here',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 135, 132, 132)
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white
                      ),
                      ),
                      icon: Icon(
                        Icons.search
                      ),
                    ),
                  ),
                ),
                Text(
                  'Current Location: $city',
                  style: TextStyle(
                    fontSize: 22,
                    color: const Color.fromARGB(255, 145, 190, 204)
                  ),
                ),
                Container(
                  alignment: Alignment(0, 0),
                  width: 300,
                  height: 200,
                  margin: EdgeInsets.only(
                    left: 45,
                    top: 15,
                    right: 45
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 42, 41, 41),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(174, 9, 9, 9),
                        blurRadius: 15
                      )
                    ],
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "$currentTemprature °C"
                        ,style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500
                        ),
                        ),
                      getWeatherIcon(currentWeatherStatus),
                      Text(
                        "$currentWeatherStatus",
                    
                      )
                        
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 150,
                    top: 20
                  ),
                  child: Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       for (int i = 0 ; i < 5 ; i++)
                //         HourlyWeatherStatus(
                //           time: data["list"][i+1]["dt"].toString(),
                //           icon: getWeatherIconHourly(data["list"][i+1]["weather"][0]["main"]),
                //           temprature: "${data["list"][i+1]["main"]["temp"]} K",
                //         )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      final time = DateTime.parse(data["list"][index+1]["dt_txt"]);
                      return  HourlyWeatherStatus(
                             time: DateFormat.j().format(time),
                             icon: getWeatherIconHourly(data["list"][index+1]["weather"][0]["main"]),
                             temprature: "${data["list"][index+1]["main"]["temp"]} °C");
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 85,
                    top: 20
                  ),
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AdditionalInfo(
                        icon: Icon(
                          Icons.water_drop_outlined,
                        ),
                        label: "Humidity",
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icon(
                          Icons.speed,
                        ),
                        label: "Pressure",
                        value: currentPressure.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icon(
                          Icons.water_drop_outlined,
                        ),
                        label: "Wind Speed",
                        value: windSpeed.toString(),
                      ),
                    ],
                  ),
                ),
              ],
                      ),
            ),
          );
        },
      ),
    );
  }
}


import 'dart:async';

import 'package:api_last_demo/controller/API%20MANGER/api_manager.dart';
import 'package:api_last_demo/model/weather_model.dart';
import 'package:api_last_demo/view/cities_screen.dart';
import 'package:api_last_demo/view/components/widgets.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherScreen extends StatefulWidget {
  final arham;
  WeatherScreen([this.arham]);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    getTime();
    getWeather();
    super.initState();
  }

  var date;

  WeatherModel? selectedWeather;

  getWeather() async {
    var permsissionGranted = await Permission.location.isGranted;
    if (permsissionGranted && widget.arham == null) {
      print("done");
      var location = Location();
      var locationData = await location.getLocation();

      var data = await ApiManager.getWeatherByLatLong(
          locationData.latitude, locationData.longitude);
      selectedWeather = WeatherModel.fromJson(data);
      print(selectedWeather);
      setState(() {});
    } else {
      print("not done");
      await Permission.location.request();
      var data =
          await ApiManager.getWeatherByCity('${widget.arham ?? 'london'}');
      selectedWeather = WeatherModel.fromJson(data);
      setState(() {});
    }

    //  print(d);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          getWeather();
      //  if(await Permission.location.isGranted){
      //   var location = Location();
      //   var dat = await location.getLocation();
      //   print(dat);
      //  }else{
      //   await Permission.location.request();
      //  }
     
        },
      ),
      body: selectedWeather == null
          ? Center(
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.cyanAccent,
                  )),
            )
          : Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/${imageSelector(selectedWeather!.weather![0].main)}"),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  CustomImage(
                    size: size.height / 2,
                    url: "",
                  ),
                  CustomText(
                    text: "${selectedWeather!.name}",
                    fontSize: 40,
                  ),
                  date == null
                      ? CircularProgressIndicator.adaptive()
                      : CustomText(text: date),
                  CustomText(
                    text: "${tempConverter(selectedWeather!.main!.temp)}°C",
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  MaterialButton(
                    color: Colors.cyan,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CityScreen()));
                    },
                    child: Text("Search"),
                  )
                ],
              ),
            ),
    );
  }

  tempConverter(temp) {
    return (temp - 273).round();
  }

  imageSelector(image) {
    // print(image);
    var finalImage;
    var weatherImage = image.toString().toLowerCase();
    if (weatherImage == "cloud" || weatherImage == "Cloud") {
      finalImage = "cloud.jpeg";
    } else if (weatherImage == "haze") {
      finalImage = "haze.jpeg";
    } else if (weatherImage == "smoke") {
      finalImage = "smog.jpeg";
    } else if (weatherImage == "sunny") {
      finalImage = "sunny.jpeg";
    } else {
      finalImage = "Weather.jpg";
    }

    return finalImage;
  }

  // var count = 0;
  Timer? timer;
  getTime() {
    // var date;
    var timer = Timer.periodic(Duration(seconds: 1), (time) {
      date = DateFormat("yyyy-MMMM-dd hh:mm:ss").format(DateTime.now());
      setState(() {
        // count++;
        // print(date);
      });
    });

    //  return Text("${date}");
  }
}

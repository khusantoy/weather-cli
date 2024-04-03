import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ansi/ansi.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  //clear terminal
  print("\x1B[2J\x1B[0;0H");

  print(bgBlue("  Weather App  \n"));
  print(red("Type exit to exit!\n"));
  stdout.write("Enter a city name: ");
  String? city = stdin.readLineSync();

  if (city!.toLowerCase() == 'exit') {
    print(red("You leaved!"));
    exit(0);
  }

  while (city == '') {
    stdout.write("Enter a city name: ");
    city = stdin.readLineSync();

    if (city!.toLowerCase() == 'exit') {
      print(red("You leaved!"));
      exit(0);
    }
  }

  const API_KEY = "4598024ad9371878506d81c6c262f3b1";

  var url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$API_KEY");

  http.get(url).then((data) {
    // Status Code
    int statusCode = data.statusCode;

    if (statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(data.body);

      // Set Values
      String name = response['name'];
      String main = response['weather'][0]['main'];
      String description = response['weather'][0]['description'];
      double temp = response['main']['temp'];
      int humadity = response['main']['humidity'];
      double wind = response['wind']['speed'];

      // Sunrise and Sunset formatting
      int sunriseTimestamp = response['sys']['sunrise'];
      int sunsetTimestamp = response['sys']['sunset'];

      DateTime sunriseDate =
          DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
      DateTime sunsetDate =
          DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

      // Format date and time
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

      String formattedSunrise = formatter.format(sunriseDate);
      String formattedSunset = formatter.format(sunsetDate);

      Weather weather = Weather(
          name: name,
          main: main,
          description: description,
          temp: temp,
          humadity: humadity,
          wind: wind,
          formattedSunrise: formattedSunrise,
          formattedSunset: formattedSunset);
      weather.displayWeather();
    } else if (statusCode == 404) {
      print(red("Not found!"));
    } else {
      print(red("Something went wrong. Try again later!"));
    }
  });
}

class Weather {
  final String name;
  final String main;
  final String description;
  final double temp;
  final int humadity;
  final double wind;
  final String formattedSunrise;
  final String formattedSunset;

  Weather(
      {required this.name,
      required this.main,
      required this.description,
      required this.temp,
      required this.humadity,
      required this.wind,
      required this.formattedSunrise,
      required this.formattedSunset});

  void displayWeather() {
    print("""

${bgGreen("  Weather report: $name  \n")}
${green("Main:")} $main ($description)
${green("Temp:")} $temp °C
${green("Humadity:")} $humadity %
${green("Wind:")} $wind km/h
${yellow("Sunrise:")} $formattedSunrise
${yellow("Sunset:")} $formattedSunset
${green('------------------------------')}""");
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ansi/ansi.dart';
import 'package:intl/intl.dart';

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

  var url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=4598024ad9371878506d81c6c262f3b1");

  http.get(url).then((data) {
    // Status Code
    int statusCode = data.statusCode;

    if (statusCode == 200) {
      var response = jsonDecode(data.body);

      // Get Values
      String name = response['name'];
      String main = response['weather'][0]['main'];
      String description = response['weather'][0]['description'];
      int temp = response['main']['temp'].ceil();
      int humadity = response['main']['humidity'];
      double wind = response['wind']['speed'];

      // Show Values
      print('');
      print(bgGreen("  Weather report: $name  \n"));
      print("${green("Main:")} $main ($description)");
      print("${green("Temp:")} $temp °C");
      print("${green("Humadity:")} $humadity %");
      print("${green("Wind:")} $wind km/h");

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

      print('${yellow("Sunrise:")} $formattedSunrise');
      print('${yellow("Sunset:")} $formattedSunset');
      print(green('------------------------------'));
    } else if (statusCode == 404) {
      print(red("Not found!"));
    } else {
      print(red("Something went wrong. Try again later!"));
    }
  });
}

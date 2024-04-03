import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ansi/ansi.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';

void main() {
  //clear terminal
  print("\x1B[2J\x1B[0;0H");

  print(bgBlue("  Ob-havo dasturi  \n"));
  print(red("Shahar nomini kiriting\n"));
  stdout.write("Shahar nomini kiriting: ");
  String? city = stdin.readLineSync();

  if (city!.toLowerCase() == 'exit') {
    print(red("Dasturdan chiqdingiz!"));
    exit(0);
  }

  //check city exists
  while (city == '') {
    stdout.write("Shahar nomini kiriting: ");
    city = stdin.readLineSync();

    if (city!.toLowerCase() == 'exit') {
      print(red("Dasturdan chiqdingiz!"));
      exit(0);
    }
  }

  //API KEY 
  const API_KEY = "4598024ad9371878506d81c6c262f3b1";

  var url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$API_KEY");

  http.get(url).then((data) async {
    // Status Code
    int statusCode = data.statusCode;

    if (statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(data.body);

      //translator
      final translator = GoogleTranslator();

      // Set Values
      String name = response['name'];
      String main = response['weather'][0]['main'];
      String description = response['weather'][0]['description'];

      //translate main to uzbek
      Translation translatedMain;
      var translation1 = await translator.translate(main, from: 'en', to: 'uz');
      translatedMain = translation1;

      //translate description to uzbek
      Translation translatedDescription;
      var translation2 = await translator.translate(description, from: 'en', to: 'uz');
      translatedDescription = translation2;

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
          main: translatedMain,
          description: translatedDescription,
          temp: temp,
          humadity: humadity,
          wind: wind,
          formattedSunrise: formattedSunrise,
          formattedSunset: formattedSunset);
      weather.displayWeather();
    } else if (statusCode == 404) {
      print(red("Manzil topilmadi!"));
    } else {
      print(red("Nimadir xato. Keyinroq qaytadan urunib ko'ring!"));
    }
  });
}
// weather model
class Weather {
  //fields
  final String name;
  final Translation main;
  final Translation description;
  final double temp;
  final int humadity;
  final double wind;
  final String formattedSunrise;
  final String formattedSunset;

  //constructor
  Weather(
      {required this.name,
      required this.main,
      required this.description,
      required this.temp,
      required this.humadity,
      required this.wind,
      required this.formattedSunrise,
      required this.formattedSunset});

  //display info
  void displayWeather() {
    print("""

${bgGreen("  Ob-havo hisoboti: $name  \n")}
${green("Asosiy:")} $main ($description)
${green("Daraja:")} $temp °C
${green("Namlik:")} $humadity %
${green("Shamol:")} $wind km/h
${yellow("Quyosh chiqishi:")} $formattedSunrise
${yellow("Quyosh botishi:")} $formattedSunset
${green('------------------------------')}""");
  }
}

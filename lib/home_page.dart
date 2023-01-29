import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:havadurumu/search_page.dart';
import "package:http/http.dart" as http;

import 'widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Ankara";
  double? temperature;
  String key = "66e5566f334ab5214dcb11bedc53cfc5";
  var locationdata;
  String code = "indir";
  String? imageweather = "";

  List<String> ikon = ["01d", "01n", "11d", "13d", "50d"];
  List<double> derece = [10, 20, 30, 40, 50];
  List<String> tarih = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma"];

  Future<void> getLocation() async {
    locationdata = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$key"),
    );
    final dataparsed = jsonDecode(locationdata.body);

    setState(() {
      temperature = dataparsed["main"]["temp"];
      location = dataparsed["name"];
      code = dataparsed["weather"][0]["main"];
      imageweather = dataparsed["weather"][0]["icon"];
    });
  }

  Future<void> getFiveDaysForecast() async {
    var forecastData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$location&units=metric&appid=$key"));
    var forecastDataParsed = jsonDecode(forecastData.body);

    ikon.clear();
    derece.clear();
    tarih.clear();

    setState(() {
      for (int i = 7; i <= 39; i = i + 8) {
        ikon.add(forecastDataParsed["list"][i]["weather"][0]["icon"]);
        derece.add(forecastDataParsed["list"][i]["main"]["temp"]);
        tarih.add(forecastDataParsed["list"][i]["dt_txt"]);
      }
    });
  }

  @override
  void initState() {
    getLocation();
    getFiveDaysForecast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/$code.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: (temperature == null)
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text(
                    "Data Getiriliyor...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Image.network(
                          "http://openweathermap.org/img/wn/$imageweather@4x.png"),
                    ),
                    Text(
                      "$temperature° C",
                      style: const TextStyle(
                          fontSize: 70, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location,
                          style: const TextStyle(fontSize: 30),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchPage(),
                              ),
                            );
                            location = selectedCity;
                            getLocation();
                            getFiveDaysForecast();
                          },
                          icon: const Icon(Icons.search),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    buildDailyWeatherCard(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildDailyWeatherCard(BuildContext context) {
    List<DailyWeatherCard> cards = [];

    for (int i = 0; i < 5; i++) {
      cards.add(DailyWeatherCard(
          icon: ikon[i], temperature: derece[i], date: tarih[i]));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView(scrollDirection: Axis.horizontal, children: cards),
    );
  }
}

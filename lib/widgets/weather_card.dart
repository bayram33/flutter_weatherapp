import "package:flutter/material.dart";

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard(
      {Key? key,
      required this.icon,
      required this.temperature,
      required this.date})
      : super(key: key);
  final String icon;
  final double temperature;
  final String date;

  @override
  Widget build(BuildContext context) {
    List<String> day = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    String showDay = day[DateTime.parse(date).weekday - 1];
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        width: 115,
        height: 120,
        child: Column(
          children: [
            Image.network("http://openweathermap.org/img/wn/$icon@2x.png"),
            Text(
              "$temperature° C",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(showDay),
          ],
        ),
      ),
    );
  }
}

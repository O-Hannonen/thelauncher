import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/services/weatherService.dart';
import 'package:get/get.dart';

class WeatherWidget extends StatefulWidget {
  WeatherWidget({Key key}) : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherService weatherService = locator<WeatherService>();

  String KtoC(num k) {
    if (k == null) {
      return "-";
    }
    num output = k - 273.15;
    return output.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weatherService.getWeather(),
      builder: (context, snapshot) {
        return NeumorphicButton(
          width: Get.width - 30,
          padding: const EdgeInsets.all(15.0),
          onTap: () {},
          child: weatherService.weatherModel != null
              ? Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          width: Get.width,
                          height: Get.width,
                          child: Image.network(
                            weatherService.weatherModel.iconUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Flexible(
                      flex: 4,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${KtoC(weatherService.weatherModel.degrees)}°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 55.0,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Feels like ${KtoC(weatherService.weatherModel.feelsLike)}°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        );
      },
    );
  }
}

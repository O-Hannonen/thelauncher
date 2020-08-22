import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/services/schoolLunchService.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SchoolLunch extends StatefulWidget {
  SchoolLunch({Key key}) : super(key: key);

  @override
  _SchoolLunchState createState() => _SchoolLunchState();
}

class _SchoolLunchState extends State<SchoolLunch> {
  DateTime day = DateTime.now();
  SchoolLunchService lunchService = locator<SchoolLunchService>();
  List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool refreshed = await lunchService.refreshList();

      if (refreshed && mounted) {
        setState(() {});
      }
    });
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      width: Get.width - 30,
      padding: const EdgeInsets.all(15.0),
      onTap: () {
        setState(() {
          if (day.weekday == 7) {
            day = DateTime(day.year, day.month, day.day - 6);
          } else {
            day = DateTime(day.year, day.month, day.day + 1);
          }
        });
      },
      child: lunchService.weeksMeals != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${weekDays[day.weekday - 1]} lunch, week ${weekNumber(day)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  lunchService.weeksMeals.length > day.weekday - 1
                      ? lunchService.weeksMeals[day.weekday - 1]
                      : "-",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          : CircularProgressIndicator(),
    );
  }
}

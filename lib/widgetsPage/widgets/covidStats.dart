import 'package:flutter/material.dart';
import 'package:thelauncher/reusableWidgets/neumorphicButton.dart';
import 'package:thelauncher/services/covidDataService.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:get/get.dart';
import 'package:thelauncher/widgetsPage/widgets/GenderChart.dart';

class CovidStatsBox extends StatefulWidget {
  CovidStatsBox({Key key}) : super(key: key);

  @override
  _CovidStatsBoxState createState() => _CovidStatsBoxState();
}

class _CovidStatsBoxState extends State<CovidStatsBox> {
  CovidDataService data = locator<CovidDataService>();
  @override
  void initState() {
    super.initState();
    data.refreshData().then((value) {
      if (mounted && value) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      width: Get.width - 30,
      padding: const EdgeInsets.all(15.0),
      child: data.totalCasesByAge == null ||
              data.totalCasesByDay == null ||
              data.totalCasesByGender == null
          ? CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "Total\n${data.totalCasesByGender["total"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "Today\n${data.totalCasesByDay.last}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: Get.width - 30,
                  height: Get.width - 30,
                  child: SimplePieChart(
                    data: [
                      new CasesByGender(
                        "male\n${data.totalCasesByGender["male"]}",
                        data.totalCasesByGender["male"],
                      ),
                      new CasesByGender(
                        "female\n${data.totalCasesByGender["female"]}",
                        data.totalCasesByGender["female"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

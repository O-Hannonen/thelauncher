import 'package:flutter/material.dart';
import 'package:thelauncher/widgetsPage/widgets/HomeControl.dart';
import 'package:thelauncher/widgetsPage/widgets/SchoolLunch.dart';
import 'package:thelauncher/widgetsPage/widgets/covidStats.dart';
import 'package:thelauncher/widgetsPage/widgets/weatherWidget.dart';

class WidgetsPage extends StatefulWidget {
  WidgetsPage({Key key}) : super(key: key);

  @override
  _WidgetsPageState createState() => _WidgetsPageState();
}

class _WidgetsPageState extends State<WidgetsPage> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CovidStatsBox(
                    key: UniqueKey(),
                  ),
                  HomeControl(
                    key: UniqueKey(),
                  ),
                  SchoolLunch(
                    key: UniqueKey(),
                  ),
                  WeatherWidget(
                    key: UniqueKey(),
                  )
                ] //children,
                ),
          ),
        ),
      ),
    );
  }
}

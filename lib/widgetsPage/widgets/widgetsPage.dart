import 'package:flutter/material.dart';
import 'package:thelauncher/services/covidDataService.dart';
import 'package:thelauncher/services/service_locator.dart';
import 'package:thelauncher/widgetsPage/SchoolLunch.dart';
import 'package:thelauncher/widgetsPage/widgets/covidStats.dart';

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
                  SchoolLunch(
                    key: UniqueKey(),
                  ),
                ] //children,
                ),
          ),
        ),
      ),
    );
  }
}

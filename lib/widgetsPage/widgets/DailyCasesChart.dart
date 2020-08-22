import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyCasesChart extends StatelessWidget {
  final List<CasesDaily> data;

  DailyCasesChart({this.data});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      getSeries(d: data),
      animate: true,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.ColorUtil.fromDartColor(Get.theme.primaryColor),
          ),
        ),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          dataIsInWholeNumbers: true,
          desiredTickCount: 10,
        ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.ColorUtil.fromDartColor(Get.theme.primaryColor),
          ),
        ),
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'd',
            transitionFormat: 'MM/dd/yyyy',
          ),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CasesDaily, DateTime>> getSeries({
    List<CasesDaily> d,
  }) {
    final data = d;

    return [
      new charts.Series<CasesDaily, DateTime>(
        id: 'Sales',
        domainFn: (CasesDaily sales, _) => sales.date,
        measureFn: (CasesDaily sales, _) => sales.cases,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Get.theme.primaryColor),
        data: data,
      )
    ];
  }
}

class CasesDaily {
  final DateTime date;
  final int cases;

  CasesDaily({this.date, this.cases});
}

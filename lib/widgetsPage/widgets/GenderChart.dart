/// Simple pie chart example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimplePieChart extends StatelessWidget {
  final List<CasesByGender> data;

  SimplePieChart({this.data});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      getSeries(d: data),
      animate: true,
      // Add an [ArcLabelDecorator] configured to render labels outside of the
      // arc with a leader line.
      //
      // Text style for inside / outside can be controlled independently by
      // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
      //
      // Example configuring different styles for inside/outside:
      //       new charts.ArcLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          )
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CasesByGender, String>> getSeries({
    List<CasesByGender> d,
  }) {
    final data = d ??
        [
          new CasesByGender("male", 100),
          new CasesByGender("female", 75),
        ];

    return [
      new charts.Series<CasesByGender, String>(
        id: 'Sales',
        domainFn: (CasesByGender sales, _) => sales.gender,
        measureFn: (CasesByGender sales, _) => sales.cases,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class CasesByGender {
  final String gender;
  final int cases;

  CasesByGender(this.gender, this.cases);
}

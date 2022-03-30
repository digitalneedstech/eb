import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<dynamic,String>> seriesList;
  final bool animateProperty;

  SimpleBarChart(this.seriesList, {required this.animateProperty});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animateProperty,
    );
  }

}

/// Sample ordinal data type.
class OrdinalSales {
  final String date;
  final int sales;

  OrdinalSales(this.date, this.sales);
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Bar_Chart extends StatefulWidget {

  const Bar_Chart({Key? key}) : super(key: key);

  @override
  State<Bar_Chart> createState() => _Bar_ChartState();
}

class _Bar_ChartState extends State<Bar_Chart> {
  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SfCartesianChart(
            title: ChartTitle(text: 'Continent wise GDP - 2021'),
            legend: Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries>[
              BarSeries<GDPData, String>(
                  name: 'GDP',
                  dataSource: _chartData,
                  xValueMapper: (GDPData gdp, _) => gdp.continent,
                  yValueMapper: (GDPData gdp, _) => gdp.gdp,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true)
            ],
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                title: AxisTitle(text: 'GDP in billions of U.S. Dollars')),
          ),
        ));
  }
}

List<GDPData> getChartData() {
  final List<GDPData> chartData = [
    GDPData('Oceania', 1600),
    GDPData('Africa', 2490),
    GDPData('S America', 2900),
    GDPData('Europe', 23050),
    GDPData('N America', 24880),
    GDPData('Asia', 34390),
  ];
  return chartData;
}


class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final double gdp;
}

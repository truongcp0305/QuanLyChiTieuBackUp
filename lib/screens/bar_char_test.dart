import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/services/future.dart';



class BarChartSample7 extends StatefulWidget {
  final List<BarModel> DataList;
  const BarChartSample7({super.key, required this.DataList});

  static const shadowColor = Color(0xFFCCCCCC);
  static const dataList = [
    _BarData(Color(0xFFecb206), 10),
    _BarData(Color(0xFFa8bd1a), 17),
  ];

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  AsyncData services = AsyncData();

  Future<List<BarModel>> getBarData()async{
    List<BarModel> listBar = [];
    double lastWeek = await services.getBalanceLastWeek();
    listBar.add(BarModel(color: Color(0xFFecb206), value: lastWeek));
    double thisWeek = await services.getBalanceThisWeek();
    listBar.add(BarModel(color: Color(0xFFa8bd1a) , value: thisWeek  ));
    return listBar;
  }

  BarChartGroupData generateBarGroup(
      int x,
      Color color,
      double value,
      ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 60,
        ),

        // BarChartRodData(
      //   toY: shadowValue,
      //   color: BarChartSample7.shadowColor,
      //   width: 6,
      // ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.9,
              child: BarChart(
                BarChartData(
                  groupsSpace: 80,
                  alignment: BarChartAlignment.center,
                  borderData: FlBorderData(
                    show: true,
                    border: const Border.symmetric(
                      horizontal: BorderSide(
                        color: Color(0xFFececec),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      drawBehindEverything: true,
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Color(0xFF606060),
                            ),
                            textAlign: TextAlign.left,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: _IconWidget(
                              color: BarChartSample7.dataList[index].color,
                              isSelected: touchedGroupIndex == index,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                  ),
                  gridData: FlGridData(
                    show: false,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color(0xFFececec),
                      strokeWidth: 1.0,
                    ),
                  ),
                  barGroups: widget.DataList.asMap().entries.map((e) {
                    final index = e.key;
                    final data = e.value;
                    return generateBarGroup(
                      index,
                      data.color,
                      data.value,
                    );
                  }).toList(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipMargin: 0,
                      getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                          ) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rod.color,
                            fontSize: 18,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 12,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() {
                          touchedGroupIndex =
                              response.spot!.touchedBarGroupIndex;
                        });
                      } else {
                        setState(() {
                          touchedGroupIndex = -1;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 7),
                  child: Text(
                    "Tuần trước",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 71),
                  child: Text(
                    "Tuần này",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BarModel{
  Color color;
  double value;
  BarModel({required this.color, required this.value});
}

class _BarData {
  const _BarData(this.color, this.value);
  final Color color;
  final double value;
  //final double shadowValue;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.wallet : Icons.wallet,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
          (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
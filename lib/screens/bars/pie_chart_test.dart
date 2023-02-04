import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_chi_tieu/services/future.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/spending_model.dart';
import '../add_screen/spending_detail.dart';


class cirChart8 extends StatefulWidget {
  final String date;
  const cirChart8({Key? key, required this.date}) : super(key: key);

  @override
  State<cirChart8> createState() => _cirChart8State();
}

class _cirChart8State extends State<cirChart8> {

  @override
  Widget build(BuildContext context) {
    AsyncData sevice = AsyncData();
    List<ChartPData> initData = [
      ChartPData(
          x: 'Trống',
          y: 1.0,
          color: Colors.grey
      )
    ];
    List<ChartPData> checkResChart (List<ChartPData>? data){
      if(data == null){
        return initData;
      }
      else if(data.length<=0){
        return initData;
      }else{
        return data;
      }
    }

    List<SpendingModel> checkResData (List<SpendingModel>? data){
      List<SpendingModel> a = [];
      if(data == null){
        return a;
      }else if (data.isEmpty){
        return a;
      }else{
        return data;
      }
    }

    return Column(
      children: [
        //Container(height: 80,),
        FutureBuilder<List<ChartPData>>(
            future: sevice.getPieChartDataByDateOrMonth(widget.date),
            builder: (context,AsyncSnapshot<List<ChartPData>> snapshot) {
              if (snapshot.hasData){
                return Container(
                    child: SfCircularChart(
                        legend: Legend(
                            isVisible: true,
                            isResponsive: true,
                            position: LegendPosition.right
                        ),
                        series: <CircularSeries>[
                          // Render pie chart
                          PieSeries<ChartPData, String>(
                              dataSource: checkResChart(snapshot.data),
                              pointColorMapper:(ChartPData data, _) => data.color,
                              xValueMapper: (ChartPData data, _) => data.x,
                              yValueMapper: (ChartPData data, _) => data.y
                          )
                        ]
                    )
                );
              }
              return Container(
                  child: SfCircularChart(
                      legend: Legend(
                          isVisible: true,
                          isResponsive: true,
                          position: LegendPosition.right
                      ),
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<ChartPData, String>(
                            dataSource: initData,
                            pointColorMapper:(ChartPData data, _) => data.color,
                            xValueMapper: (ChartPData data, _) => data.x,
                            yValueMapper: (ChartPData data, _) => data.y
                        )
                      ]
                  )
              );
            }
        ),
        Container(
          height: 10,
          decoration: BoxDecoration(
              border: BorderDirectional(
                  top: BorderSide(color: Colors.black12, width: 2)
              )
          ),
        ),
        Container(
            child: FutureBuilder<List<SpendingModel>>(
              future: sevice.getSpendingByDateOrMonth(widget.date),
              builder: (context,AsyncSnapshot<List<SpendingModel>> snapshot){
                if(snapshot.hasData) {
                  List<SpendingModel> data = checkResData(snapshot.data);
                  if(data.isEmpty){
                    return Container(
                      margin: EdgeInsets.only(top: 110),
                      child: Center(
                        child: Text(
                          "Chưa có dữ liệu",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 25
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for(var index =0; index <data.length; index++)
                        Container(
                          decoration: BoxDecoration(
                              border: BorderDirectional(bottom: BorderSide(width: 0.5, color: Colors.black26))
                          ),
                          child: ListTile(
                            onTap: () {
                              Get.to(() =>
                                  SpendingDetail(spendModel: data[index]));
                            },
                            leading: Image.network(
                              data[index].icon,
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              data[index].money.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              data[index].category
                            ),
                          ),
                        )
                    ],
                  );
                }
                return Container();
              },
            )
        )
      ],
    );
  }
}
class ChartPData {
  ChartPData({required this.x, required this.y, required this.color});
  final String x;
  final double y;
  final Color color;
}


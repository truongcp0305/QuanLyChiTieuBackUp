import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../bars/pie_chart_test.dart';

class MainChart extends StatefulWidget {
  const MainChart({Key? key}) : super(key: key);

  @override
  State<MainChart> createState() => _MainChartState();
}

class _MainChartState extends State<MainChart> {
  @override
  Widget build(BuildContext context) {
    var dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String monthNow = DateFormat('MM').format(DateTime.now());
    RxString montSelected = monthNow.obs;
    RxString dateSelected = dateNow.toString().obs;
    RxString dateChartView = monthNow.obs;
    RxString action = 'Month'.obs;
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Obx(
                    ()=> GestureDetector(
                  onTap: ()async{
                   var newDate = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime(2028),
                    );
                   if(newDate != null){
                     action.value = 'Month';
                     montSelected.value = DateFormat('MM').format(newDate);
                     dateChartView.value = DateFormat('MM').format(newDate);
                   }
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    margin: EdgeInsets.only(top: 55, left: 70),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black26),
                      color: action.value=='Month'?Colors.greenAccent: Colors.white24,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                          "Tháng ${montSelected}"
                          //dateSelected.value
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                  ()=> GestureDetector(
                  onTap: ()async{
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2028)
                    );
                    if(newDate != null){
                      action.value = 'Day';
                      dateSelected.value = DateFormat('dd/MM/yyyy').format(newDate);
                      dateChartView.value = DateFormat('dd/MM/yyyy').format(newDate);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    margin: EdgeInsets.only(top: 55, left: 20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black26),
                      color: action.value=='Day'?Colors.greenAccent: Colors.white24,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        dateSelected.value
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //SizedBox(height: 200,),
          Expanded(
            child: ListView(
              children: [
                Obx(()=> cirChart8(date: dateChartView.value,))
              ],
            ),
          )
        ],
      ),
    );
  }
}

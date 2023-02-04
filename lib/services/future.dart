import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/spending_model.dart';
import '../screens/bars/bar_chart_2.dart';
import '../screens/bars/pie_chart_test.dart';


class AsyncData{
  FirebaseAuth auth = FirebaseAuth.instance;
  DateFormat format = DateFormat("dd/MM/yyyy");
  DateFormat formatM = DateFormat('MM');
  final oneWeek = const Duration(days: 7);
  final oneMonth = const Duration(days: 30);
  final twoWeek = const Duration(days: 14);

  Future<List<SpendingModel>> getAll()async{
    List<SpendingModel> snapshot = [];
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    for(var doc in data.docs ){
        snapshot.add(
            SpendingModel(
                id: doc['id'],
                money: doc['money'],//double.parse(doc['money'].toString().replaceAll(',', '')),
                icon: doc['icon'],
                category: doc['category'],
                time: doc['time'],
                type: doc['type'],
                note: doc['note']
            )
        );
    }
    return snapshot;
  }

  Future<List<ChartPData>> getPieChartData()async{
    List<ChartPData> chartData = [];
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    for(var doc in data.docs ){
      chartData.add(
        ChartPData(
            x: doc['category'],
            y: double.parse(doc['money'].toString().replaceAll(',', '')),
            color:  Colors.primaries[Random().nextInt(Colors.primaries.length)]
        )
      );
    }
    return chartData;
  }

  Future<List<SpendingModel>> getSpendingByDateOrMonth(String date)async{
    List<SpendingModel> listData = [];
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    if(date.length>=4){
      for(var doc in data.docs ){
        if(doc['time']==date){
          listData.add(
              SpendingModel(
                  id: doc['id'],
                  money: doc['money'],//double.parse(doc['money'].toString().replaceAll(',', '')),
                  icon: doc['icon'],
                  category: doc['category'],
                  time: doc['time'],
                  type: doc['type'],
                  note: doc['note']
              )
          );
        }
      }
    }else{
      for(var doc in data.docs){
        String docMonth = DateFormat('MM').format(format.parse(doc['time']));
        if(docMonth == date){
          listData.add(
              SpendingModel(
                  id: doc['id'],
                  money: doc['money'],//double.parse(doc['money'].toString().replaceAll(',', '')),
                  icon: doc['icon'],
                  category: doc['category'],
                  time: doc['time'],
                  type: doc['type'],
                  note: doc['note']
              )
          );
        }
      }
    }
    return listData;
  }

  Future<List<ChartPData>> getPieChartDataByDateOrMonth(String date)async{
    List<ChartPData> chartData = [];
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    if(date.length >= 4){
      for(var doc in data.docs){
        if(doc['time']==date){
          chartData.add(
              ChartPData(
                  x: doc['category'],
                  y: double.parse(doc['money'].toString().replaceAll(',', '')),
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
              )
          );
        }
      }
    }else{
      for(var doc in data.docs){
        String docMonth = DateFormat('MM').format(format.parse(doc['time']));
        if(docMonth == date){
          chartData.add(
              ChartPData(
                  x: doc['category'],
                  y: double.parse(doc['money'].toString().replaceAll(',', '')),
                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
              )
          );
        }
      }
    }
    return chartData;
  }

  Future<List<ChartPData>> getPieChartDataByMonth(String monthReq)async{
    List<ChartPData> chartData =[];
    var data = await FirebaseFirestore.instance
    .collection(auth.currentUser?.email.toString()??'unknow').get();
    for(var doc in data.docs){
      String docMonth = DateFormat('MM').format(format.parse(doc['time']));
      if(docMonth == monthReq){
        chartData.add(
          ChartPData(x: doc['category'],
              y: double.parse(doc['money'].toString().replaceAll(',', '')),
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
          )
        );
      }
    }
    return chartData;
  }

  Future<double> getBalanceLastWeek ()async{
    double balance = 0;
    String dateNow = format.format(DateTime.now());
    Duration weekDay;
    String E = DateFormat('EEE').format(DateTime.now());
    switch(E){
      case 'Mon': weekDay = const Duration(days: 0); break;
      case 'Tue': weekDay = const Duration(days: 1); break;
      case 'Wed': weekDay = const Duration(days: 2); break;
      case 'Thu': weekDay = const Duration(days: 3); break;
      case 'Fri': weekDay = const Duration(days: 4); break;
      case 'Sat': weekDay = const Duration(days: 5); break;
      case 'Sun': weekDay = const Duration(days: 6); break;
      default : weekDay = const Duration(days: 0); break;
    }
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    for(var doc in data.docs ){
      String date = doc['time'];
      Duration sub = format.parse(dateNow).difference(format.parse(date));
      print(sub.inDays.toString());
      if(sub<=oneWeek+weekDay && sub>weekDay){
        if(doc['type']=='-'){
          balance += int.parse(doc['money'].toString().replaceAll(',', ''));
        }
      }
    }
    return balance;
  }

  Future<double> getBalanceThisWeek ()async{
    double balance = 0;
    String dateNow = format.format(DateTime.now());
    Duration weekDay;
    String E = DateFormat('EEE').format(DateTime.now());
    switch(E){
      case 'Mon': weekDay = const Duration(days: 0); break;
      case 'Tue': weekDay = const Duration(days: 1); break;
      case 'Wed': weekDay = const Duration(days: 2); break;
      case 'Thu': weekDay = const Duration(days: 3); break;
      case 'Fri': weekDay = const Duration(days: 4); break;
      case 'Sat': weekDay = const Duration(days: 5); break;
      case 'Sun': weekDay = const Duration(days: 6); break;
      default : weekDay = const Duration(days: 0); break;
    }
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    for(var doc in data.docs ){
      String date = doc['time'];
      Duration sub = format.parse(dateNow).difference(format.parse(date));
      if(sub<=weekDay){
       if(doc['type']=='-'){
          balance += int.parse(doc['money'].toString().replaceAll(',', ''));
        }
      }
    }
    return balance;
  }

  Future<String> getPlanPercent(String category, String plan)async{
    double sum = 0.0;
    String monthNow = DateFormat('MM').format(DateTime.now());
    String result = '';
    String coll = auth.currentUser?.email.toString()??'unknow';
    var data = await FirebaseFirestore.instance.collection(coll)
        .get();
    for(var doc in data.docs){
      String docMonth = DateFormat('MM').format(format.parse(doc['time']));
      if(docMonth == monthNow && doc['category']==category){
        sum += double.parse(doc['money'].toString().replaceAll(',', ''));
        print('sum=${sum}');
      }
    }
    result = "${sum / double.parse(plan)*100}";
    return result;
  }

  Future<List<SubscriberSeries>> getBarData()async{
    List<SubscriberSeries> listBar = [];
    double lastWeek = await getBalanceLastWeek();
    listBar.add(SubscriberSeries(year: "Tuần trước", subscribers: lastWeek, barColor: ColorUtil.fromDartColor(Colors.blue)));
    double thisWeek = await getBalanceThisWeek();
    listBar.add(SubscriberSeries(year: "Tuần này", subscribers: thisWeek, barColor: ColorUtil.fromDartColor(Colors.red)));
    return listBar;
  }

}
import 'dart:convert';
import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/models/plan_model.dart';
import '../models/spending_model.dart';
import '../repository/api.dart';
import '../screens/bars/bar_chart_2.dart';
import '../screens/bars/pie_chart_test.dart';
import 'package:http/http.dart' as http;



class AsyncData {
  final domain = "http://192.168.214.146:1234";
  FirebaseAuth auth = FirebaseAuth.instance;
  DateFormat format = DateFormat("dd/MM/yyyy");
  //DateFormat format = DateFormat('EEE, M/d/y');
  DateFormat formatM = DateFormat('dd/MM/yyyy');
  //DateFormat formatM = DateFormat('EEE, M/d/y');
  final oneWeek = const Duration(days: 7);
  final oneMonth = const Duration(days: 30);
  final twoWeek = const Duration(days: 14);
  final api = Api();
  List<MaterialColor> colors = [
    Colors.orange,
    Colors.lightBlue,
    Colors.brown, Colors.indigo, Colors.red, Colors.green,
    Colors.deepPurple, Colors.grey, Colors.purple,
    Colors.yellow, Colors.deepPurple, Colors.blueGrey,
    Colors.lightGreen, Colors.indigo, Colors.lightBlue,
    Colors.red, Colors.teal, Colors.deepOrange,
    Colors.lightGreen, Colors.brown, Colors.pink,
  ];


  Future<List<SpendingModel>> getAllBill() async {
    // List<SpendingModel> snapshot = [];
    // var data = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .get();
    // for (var doc in data.docs) {
    //   snapshot.add(
    //       SpendingModel(
    //           id: doc['id'],
    //           money: doc['money'],
    //           //double.parse(doc['money'].toString().replaceAll(',', '')),
    //           icon: doc['icon'],
    //           category: doc['category'],
    //           time: doc['time'],
    //           type: doc['type'],
    //           note: doc['note']
    //       )
    //   );
    // }
    // return snapshot;
    return await api.getAllBill();
  }

  Future<List<SpendingModel>> GetTopSpendingThisWeek() async {
    List<SpendingModel> data = [];
    List<SpendingModel> snapshot = [];
    String dateNow = format.format(DateTime.now());
    Duration weekDay;
    String E = DateFormat('EEE').format(DateTime.now());
    switch (E) {
      case 'Mon':
        weekDay = const Duration(days: 0);
        break;
      case 'Tue':
        weekDay = const Duration(days: 1);
        break;
      case 'Wed':
        weekDay = const Duration(days: 2);
        break;
      case 'Thu':
        weekDay = const Duration(days: 3);
        break;
      case 'Fri':
        weekDay = const Duration(days: 4);
        break;
      case 'Sat':
        weekDay = const Duration(days: 5);
        break;
      case 'Sun':
        weekDay = const Duration(days: 6);
        break;
      default :
        weekDay = const Duration(days: 0);
        break;
    }
    // var res = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .get();
    // for (var doc in res.docs) {
    //   String date = doc['time'];
    //   Duration sub = format.parse(dateNow).difference(format.parse(date));
    //   if (sub <= weekDay) {
    //     if (doc['type'] == '-') {
    //       data.add(
    //           SpendingModel(
    //               id: doc['id'],
    //               money: doc['money'],
    //               //double.parse(doc['money'].toString().replaceAll(',', '')),
    //               icon: doc['icon'],
    //               category: doc['category'],
    //               time: doc['time'],
    //               type: doc['type'],
    //               note: doc['note']
    //           )
    //       );
    //     }
    //   }
    // }
    data  = await api.getAllBill();

    SpendingModel tg;
    for (var s = 0; s < data.length - 1; s++) {
      for (var i = s + 1; i < data.length; i++) {
        if (
        double.parse(data[s].money.toString().replaceAll(',', ''))
            < double.parse(data[i].money.toString().replaceAll(',', ''))
        ) {
          tg = data[s];
          data[s] = data[i];
          data[i] = tg;
        }
      }
    }
    for (var i = 0; i < data.length; i++) {
      if (i == 3) {
        return snapshot;
      }
      snapshot.add(data[i]);
    }
    return data;
  }

  Future<List<ChartPData>> getPieChartData() async {
    List<ChartPData> chartData = [];
    // var data = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .get();
    var data = await api.getAllBill();
    for (var doc in data) {
      chartData.add(
          ChartPData(
              x: doc.category,
              y: double.parse(doc.money.toString().replaceAll(',', '')),
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
          )
      );
    }
    return chartData;
  }

  Future<List<SpendingModel>> getSpendingByDateOrMonth(String date) async {
    List<SpendingModel> listData = [];
    // var data = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .get();
    var data = await api.getAllBill();
    if (date.length >= 4) {
      for (var doc in data) {
        if (doc.time == date) {
          listData.add(
              SpendingModel(
                  id: doc.id,
                  money: doc.money,
                  //double.parse(doc['money'].toString().replaceAll(',', '')),
                  icon: doc.icon,
                  category: doc.category,
                  time: doc.time,
                  type: doc.type,
                  note: doc.note
              )
          );
        }
      }
    } else {
      for (var doc in data) {
        String docMonth = DateFormat('MM').format(format.parse(doc.time));
        if (docMonth == date) {
          listData.add(
              SpendingModel(
                  id: doc.id,
                  money: doc.money,
                  //double.parse(doc['money'].toString().replaceAll(',', '')),
                  icon: doc.icon,
                  category: doc.category,
                  time: doc.time,
                  type: doc.type,
                  note: doc.note
              )
          );
        }
      }
    }
    return listData;
  }

  Future<List<ChartPData>> getPieChartDataByDateOrMonth(String date) async {
    List<ChartPData> chartData = [];
    // var data = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .get();
    var data = await api.getAllBill();
    if (date.length >= 4) {
      var i = 0;
      for (var doc in data) {
        i++;
        if (doc.time == date) {
          chartData.add(
              ChartPData(
                  x: doc.category,
                  y: double.parse(doc.money.toString().replaceAll(',', '')),
                  color: colors[i] //Colors.primaries[Random().nextInt(Colors.primaries.length)]
              )
          );
        }
      }
    } else {
      var i = 0;
      for (var doc in data) {
        i++;
        String docMonth = DateFormat('MM').format(format.parse(doc.time));
        if (docMonth == date) {
          chartData.add(
              ChartPData(
                  x: doc.category,
                  y: double.parse(doc.money.toString().replaceAll(',', '')),
                  color: colors[i] //Colors.primaries[Random().nextInt(Colors.primaries.length)]
              )
          );
        }
      }
    }
    return chartData;
  }

  Future<List<ChartPData>> getPieChartDataByMonth(String monthReq) async {
    List<ChartPData> chartData = [];
    // var data = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow').get();
    var data = await api.getAllBill();
    for (var doc in data) {
      String docMonth = DateFormat('MM').format(format.parse(doc.time));
      if (docMonth == monthReq) {
        chartData.add(
            ChartPData(x: doc.category,
                y: double.parse(doc.money.toString().replaceAll(',', '')),
                color: Colors.primaries[Random().nextInt(
                    Colors.primaries.length)]
            )
        );
      }
    }
    return chartData;
  }

  Future<double> getBalanceLastWeek() async {
    double balance = 0;
    String dateNow = format.format(DateTime.now());
    Duration weekDay;
    String E = DateFormat('EEE').format(DateTime.now());
    switch (E) {
      case 'Mon':
        weekDay = const Duration(days: 0);
        break;
      case 'Tue':
        weekDay = const Duration(days: 1);
        break;
      case 'Wed':
        weekDay = const Duration(days: 2);
        break;
      case 'Thu':
        weekDay = const Duration(days: 3);
        break;
      case 'Fri':
        weekDay = const Duration(days: 4);
        break;
      case 'Sat':
        weekDay = const Duration(days: 5);
        break;
      case 'Sun':
        weekDay = const Duration(days: 6);
        break;
      default :
        weekDay = const Duration(days: 0);
        break;
    }
    // var data = await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .get();
    var data = await api.getAllBill();

    for (var doc in data) {
      String date = doc.time;
      Duration sub = format.parse(dateNow).difference(format.parse(date));
      if (sub <= oneWeek + weekDay && sub > weekDay) {
        if (doc.type == '-') {
          balance += int.parse(doc.money.toString().replaceAll(',', ''));
        }
      }
    }
    return balance;
  }

  Future<double> getBalanceThisWeek() async {
    double balance = 0;
    String dateNow = format.format(DateTime.now());
    Duration weekDay;
    String E = DateFormat('EEE').format(DateTime.now());
    switch (E) {
      case 'Mon':
        weekDay = const Duration(days: 0);
        break;
      case 'Tue':
        weekDay = const Duration(days: 1);
        break;
      case 'Wed':
        weekDay = const Duration(days: 2);
        break;
      case 'Thu':
        weekDay = const Duration(days: 3);
        break;
      case 'Fri':
        weekDay = const Duration(days: 4);
        break;
      case 'Sat':
        weekDay = const Duration(days: 5);
        break;
      case 'Sun':
        weekDay = const Duration(days: 6);
        break;
      default :
        weekDay = const Duration(days: 0);
        break;
    }
    var data = await api.getAllBill();
    for (var doc in data) {
      String date = doc.time;
      Duration sub = format.parse(dateNow).difference(format.parse(date));
      if (sub <= weekDay) {
        if (doc.type == '-') {
          balance += int.parse(doc.money.toString().replaceAll(',', ''));
        }
      }
    }
    return balance;
  }

  Future<String> GetUserEmail() async {
    var userId = await api.getId();
    var response = await http.get(Uri.parse("$domain/user/$userId"));
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      print(parsed);
      if (parsed['username'] != null ){
        return parsed['username'];
      }
    }
    return "";
  }


  Future<String> getPlanPercent(String category, String plan) async {
    double sum = 0.0;
    String monthNow = DateFormat('MM').format(DateTime.now());
    String result = '';
    //String coll = auth.currentUser?.email.toString() ?? 'unknow';
    var data = await api.getAllBill();
    print(plan);
    for (var doc in data) {
      String docMonth = DateFormat('MM').format(format.parse(doc.time));
      if (docMonth == monthNow && doc.category == category) {
        sum += double.parse(doc.money.toString().replaceAll(',', ''));
      }
    }
    print(sum);
    result = "${(sum / double.parse(plan) * 100).toStringAsFixed(2)}";
    return result;
  }

  Future<List<SubscriberSeries>> getBarData() async {
    List<SubscriberSeries> listBar = [];
    double lastWeek = await getBalanceLastWeek();
    listBar.add(SubscriberSeries(year: "Tuần trước",
        subscribers: lastWeek,
        barColor: ColorUtil.fromDartColor(Colors.blue)));
    double thisWeek = await getBalanceThisWeek();
    listBar.add(SubscriberSeries(year: "Tuần này",
        subscribers: thisWeek,
        barColor: ColorUtil.fromDartColor(Colors.red)));
    return listBar;
  }

  Future<void> deletePlan(String keys) async {
    // String coll = auth.currentUser?.email.toString() ?? 'unknow';
    // FirebaseFirestore.instance.collection("${coll}plan")
    //     .doc(keys).delete();
    // await api.deletePlan(keys);
    var userId = await api.getId();
    var url = Uri.parse( '${domain}/plan?id=${userId}&key=$keys');
    var response = await http.delete(url);
  }

  Future<void> updatePlan(String keys, String plan, String value) async {
    // String coll = auth.currentUser?.email.toString() ?? 'unknow';
    // await FirebaseFirestore.instance
    //     .collection("${coll}plan").doc(keys)
    //     .update(
    //     {
    //       'keys': keys,
    //       'plan': plan,
    //       'value': value,
    //     }
    // );
    var userId = await api.getId();
    var url = Uri.parse( '${domain}/plan');
    var body = json.encode({
      'user_id': userId,
      'key': api.KeymappingBD(keys),
      'value': value,
      'plan': plan,
    });

    var headers = {'Content-Type': 'application/json'};
    var response = await http.put(url, headers: headers, body: body);

  }

  Future<void> addPlan(String keys, String value, String plan) async {
    // String coll = auth.currentUser?.email.toString() ?? 'unknow';
    // await FirebaseFirestore.instance.collection("${coll}plan")
    //     .doc(keys).set(
    //     {
    //       "keys": keys,
    //       "value": value,
    //       "plan": plan
    //     }
    // );
    var userId = await api.getId();
    var url = Uri.parse( '${domain}/plan');
    var body = json.encode({
      'user_id': userId,
      'key': api.KeymappingBD(keys),
      'value': value,
      'plan': plan,
    });

    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, headers: headers, body: body);
  }

  Future<bool> createBill(String id, String money, String type, String icon,
      String category, String time, DateTime myDate, String note) async {
    var userId = await api.getId();
    var url = Uri.parse( '${domain}/spend');
    var body = json.encode({
      'user_id': userId,
      'id': id,
      'money': money,
      'icon': icon,
      'type': type,
      'category': api.KeymappingBD(category),
      'time': DateFormat('dd/MM/yyyy').format(myDate),
      'note': note,
    });

    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, headers: headers, body: body);
    //
    // await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .doc(id).set(
    //     {
    //       'id': id, //DateTime.now().toString(),
    //       'money': money,
    //       'category': category,
    //       'icon': icon,
    //       'time': DateFormat('dd/MM/yyyy').format(myDate),
    //       'note': note,
    //       'type': type
    //     }
    // );
    if (response.statusCode==200){
      return true;
    }else {
      return false;
    }
    return true;
  }

  Future<void> updateBill(String id, String money, String category, String icon,
      String time, String myDate, String note, String type) async {
    // await FirebaseFirestore.instance
    //     .collection(auth.currentUser?.email.toString() ?? 'unknow')
    //     .doc(id).update(
    //     {
    //       'id': id, //DateTime.now().toString(),
    //       'money': money,
    //       'category': category,
    //       'icon': icon,
    //       'time': time,
    //       'note': note,
    //       'type': type
    //     }
    // );
   await api.updateBill(id ,money, type, icon, category, time, myDate, note);
  }

  Future<bool> createPlan(String keys, String plan, String value) async {
    List a = [];
    // String coll = auth.currentUser?.email.toString() ?? 'unknow';
    // QuerySnapshot d = await FirebaseFirestore.instance.collection("${coll}plan")
    //     .where('keys', isEqualTo: keys).get();
    var userId = await api.getId();
    var url = Uri.parse('${domain}/plan/key?id=$userId&key=$keys');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed['data'] != null){
        for (var doc in parsed['data'] as List<dynamic>) {
          a.add(PlanModel(
              key: api.DBmappingKey(doc['key']),
              value: doc['value'],
              plan: doc['plan']
          ));
        }
      }
      if (a.isEmpty) {
        if (plan != null) {
          //await createPlan(keys, plan, value);
          await addPlan(keys, value, plan);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> logout() async{
    await FirebaseAuth.instance.signOut();
    await api.logout();
  }
}
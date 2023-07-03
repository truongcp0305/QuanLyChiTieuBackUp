import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/models/spending_model.dart';
import 'package:quan_ly_chi_tieu/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import '../models/plan_model.dart';
import '../screens/bars/pie_chart_test.dart';

class Api {
  final domain = "https://toan.fly.dev/";

  String generateUUID() {
    var uuid = Uuid();
    print("uuuuuuid:");
    print(uuid.v4());
    return uuid.v4();
  }

  Future<File> getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/data.txt');
    return file;
  }

  Future<void> writeToFile (username, password) async{
    final file = await getFile();
    final sink = file.openWrite(mode: FileMode.write);
    sink.write('{"username":"$username","password":"$password"}');
    await sink.close();
  }

  Future<UserModel> readFile () async{
    final file = await getFile();
    if (await file.exists()){
      final contents = await file.readAsString();
      var decode = jsonDecode(contents);
      return UserModel(id: "", username: decode["username"], password: decode["password"]);
    }else{
      return UserModel(id: "", username: "", password: "");
    }
  }

  Future<String> getId () async{
    final user = await readFile();
    var url = Uri.parse( '${domain}user/login');
    var response = await http.post(url, body: {
    'username': user.username,
    'password': user.password,
    },);
    if (response.statusCode ==200){
      final parsed = json.decode(response.body);
      return parsed['user_id'];
    }else{
      return '';
    }
  }

  Future<bool> login(username, password) async {
    var url = Uri.parse( '${domain}user/login');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    },);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool>logout()async{
    var userId = getId();
    var url = Uri.parse( '${domain}user/logout');
    var response = await http.post(url, body: {
      'user_id': userId,
    },);
    if (response.statusCode ==200){
      return true;
    }else{
      return false;
    }
  }

  Future <UserModel> getUser() async{
    var userId = await getId();
    var url = Uri.parse( '${domain}user?user_id=${userId}');
    var response = await http.get(url);
    final parsed = json.decode(response.body);
    if (response.statusCode == 200){
      return UserModel(
          id: userId,
          username: parsed['id'],
          password: parsed['password'],
      );
    }else {
      return UserModel(id: userId, username: "", password: "");
    }
  }

  Future<bool> createUser(String username, String password) async{
    var url = Uri.parse( '${domain}user');
    var response = await http.post(url, body: {
      'user_id': generateUUID(),
      'username': username,
      'password': password,
      'email': username,
    },);
    if (response.statusCode == 200){
      return true;
    }else {
      return false;
    }
  }

  Future<bool> createBill (String id, String money, String type, String icon, String category, String time,DateTime myDate, String note)async{
    var userId = await getId();
    var url = Uri.parse( '${domain}bill');
    var response = await http.post(url, body: {
      'user_id': userId,
      'id': id,
      'money': money,
      'icon': icon,
      'type': type,
      'category': category,
      'time': time+ 'T00:00:00Z',
      'note': note,
    },);
    if (response.statusCode==200){
      return true;
    }else {
      return false;
    }
  }

  Future<List<SpendingModel>> getAllBill () async{
    var userId = await getId();
    var url = Uri.parse( 'https://toan.fly.dev/bill/getAll?user_id=$userId');
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode==200){
      final parsed = json.decode(response.body);
      List<SpendingModel> listSpend = (parsed['data'] as List<dynamic>).map((item)=> SpendingModel(
        id: item['id'],
        money: item['money'],
        icon: item['icon'],
        category: item['category'],
        time: parseDateTime(item['time']),
        type: item['type'],
        note: item['note']
      )).toList();
      return listSpend;
    }else {
      List<SpendingModel> listSpend = [];
      return listSpend;
    }
  }

  Future<SpendingModel> getBill (String id) async{
    var idUser = await getId();
    var url = Uri.parse( '${domain}bill?user_id=$idUser&id=$id');
    var response = await http.get(url);
    if (response.statusCode ==200){
      final parsed = json.decode(response.body);
      return SpendingModel(
        id: parsed['id'],
        money: parsed['money'],
        icon: parsed['icon'],
        category: parsed['category'],
        time: parsed['time'],
        type: parsed['type'],
        note: parsed['note']
      );
    }else {
      return SpendingModel(
        id: '',
        money: '',
        icon: '',
        category: '',
        time: '',
        type: '',
        note: '',
      );
    }
  }

  Future<List<SpendingModel>> getBillInWeek ()async{
    var idUser = await getId();
    var url = Uri.parse( '${domain}bill/inWeek?user_id=$idUser');
    var response = await http.get(url);
    if (response.statusCode==200){
      final parsed = json.decode(response.body);
      List<SpendingModel> listSpend = (parsed['data'] as List<dynamic>).map((item)=> SpendingModel(
          id: item['id'],
          money: item['money'],
          icon: item['icon'],
          category: item['category'],
          time: item['time'],
          type: item['type'],
          note: item['note']
      )).toList();
      return listSpend;
    }else {
      List<SpendingModel> listSpend = [];
      return listSpend;
    }
  }

  Future<List<SpendingModel>> getBillByDay (String userId, String day)async{
    var iduser = await getId();
    var url = Uri.parse( '${domain}bill/byDay?user_id=$iduser&day=$day');
    var response = await http.get(url);
    if (response.statusCode==200){
      final parsed = json.decode(response.body);
      List<SpendingModel> listSpend = (parsed['data'] as List<dynamic>).map((item)=> SpendingModel(
          id: item['id'],
          money: item['money'],
          icon: item['icon'],
          category: item['category'],
          time: item['time'],
          type: item['type'],
          note: item['note']
      )).toList();
      return listSpend;
    }else {
      List<SpendingModel> listSpend = [];
      return listSpend;
    }
  }

  Future<bool> deleteBill (String id)async{
    var userId = await getId();
    await getUsers(id);
    var url = Uri.parse( '${domain}bill');
    var response = await http.delete(url, body: {
      'user_id': userId,
      'id': id,
    });
    if (response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> updateBill (String id, String money, String type, String icon, String category, String time,String mydate, String note)async{
    var userId = await getId();
    var url = Uri.parse( '${domain}bill');
    var response = await http.put(url, body: {
      'user_id': userId,
      'id': id,
      'money': money,
      'icon': icon,
      'type': type,
      'category': category,
      'time': mydate+ 'T00:00:00Z',
      'note': note,
    },);
    if (response.statusCode==200){
      return true;
    }else {
      return false;
    }
  }

  String parseDateTime(String datetime){
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    var time = datetime.replaceAll('T00:00:00Z', '');
    DateTime myDate = DateFormat('yyyy-MM-dd').parse(time);
    var result = dateFormat.format(myDate);
    return result;
  }

  Future<List<SpendingModel>> GetTopSpendingThisWeek ()async {
    var userId = await getId();
    var url = Uri.parse('https://toan.fly.dev/bill/thisWeek?user_id=$userId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      List<SpendingModel> listSpend = (parsed['data'] as List<dynamic>).map((
          item) =>
          SpendingModel(
              id: item['id'],
              money: item['money'],
              icon: item['icon'],
              category: item['category'],
              time: item['time'],
              type: item['type'],
              note: item['note']
          )).toList();
      listSpend.sort((a, b) => int.parse(b.money).compareTo(int.parse(a.money)));
      if (listSpend.length >3 ){
        var top = listSpend.take(3).toList();
        return top;
      }else {
        List<SpendingModel> top = [];
        for (var i=0; i<listSpend.length; i++){
          top.add(listSpend[i]);
        }
        return top;
      }
    }else{
      List<SpendingModel> listSpend = [];
      return listSpend;
    }
  }

  Future<List<PlanModel>> GetAllPlan() async{
    var userId = await getId();
    var url = Uri.parse('https://toan.fly.dev/plan/getAll?user_id=$userId');
    var response = await http.get(url);
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      List<PlanModel> plans = (parsed['data'] as List<dynamic>).map((item) =>
          PlanModel(value: parsed['value'], key: parsed['key'], plan: parsed['plan'])
      ).toList();
      return plans;
    }else{
       List<PlanModel> plans = [];
      return plans;
    }

  }

  Future<bool> createPlan(String key,String value, String plan )async{
    var userId = await getId();
    var url = Uri.parse( '${domain}plan');
    var response = await http.post(url, body: {
      'user_id': userId,
      'key': key,
      'value': value,
      'plan': plan,
    },);
    if (response.statusCode==200){
      return true;
    }else {
      return false;
    }
  }
  Future<bool> updatePlan(String key, String value, String plan)async{
    var userId = await getUser();
    var url = Uri.parse('${domain}plan');
    var respone = await http.put(url, body: {
      'user_id': userId,
      'key': key,
      'value': value,
      'plan':plan
    });
    if (respone.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> deletePlan(String key)async{
    var userId = await getUser();
    var url = Uri.parse('${domain}plan');
    var respone = await http.delete(url, body:{
      'user_id': userId,
      'key': key,
    });
    deleteKeys(key);
    if (respone.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  Future<List<ChartPData>> getPieChartData()async{
    var userId = await getId();
    var url = Uri.parse('https://toan.fly.dev/plan/getAll?user_id=$userId');
    var response = await http.get(url);
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      List<ChartPData> chartData = (parsed['data'] as List<dynamic>).map((item) =>
          ChartPData(
              x: parsed['category'],
              y: double.parse(parsed['money'].toString().replaceAll(',', '')),
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)])
      ).toList();
      return chartData;
    }else{
      List<ChartPData> chartPdata = [];
      return chartPdata;
    }
  }


  Future<double> getBalanceLastWeek() async {
    double balance = 0;
    var userId = await getId();
    var url = Uri.parse('https://toan.fly.dev/plan/lastWeek?user_id=$userId');
    var response = await http.get(url);
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      List<SpendingModel> listSpend = (parsed['data'] as List<dynamic>).map((
          item) =>
          SpendingModel(
              id: item['id'],
              money: item['money'],
              icon: item['icon'],
              category: item['category'],
              time: item['time'],
              type: item['type'],
              note: item['note']
          )).toList();
      for(var doc in listSpend ){
          if(doc.type=='-'){
            balance += int.parse(doc.money.toString().replaceAll(',', ''));
          }
      }
    }
    return balance;
  }

  Future<double> getBalanceThisWeek() async {
    double balance = 0;
    var userId = await getId();
    var url = Uri.parse('https://toan.fly.dev/plan/thisWeek?user_id=$userId');
    var response = await http.get(url);
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      List<SpendingModel> listSpend = (parsed['data'] as List<dynamic>).map((
          item) =>
          SpendingModel(
              id: item['id'],
              money: item['money'],
              icon: item['icon'],
              category: item['category'],
              time: item['time'],
              type: item['type'],
              note: item['note']
          )).toList();
      for(var doc in listSpend ){
        if(doc.type=='-'){
          balance += int.parse(doc.money.toString().replaceAll(',', ''));
        }
      }
    }
    return balance;
  }

  Future<void> getUsers (id) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance.collection(auth.currentUser?.email.toString()??'unknow')
        .doc(id).delete();
  }

  Future<void> deleteKeys (String keys) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    String coll = auth.currentUser?.email.toString()??'unknow';
    FirebaseFirestore.instance.collection("${coll}plan")
        .doc(keys).delete();
  }


}

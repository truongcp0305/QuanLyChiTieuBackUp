
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/repository/api.dart';
import 'package:quan_ly_chi_tieu/screens/add_screen/category.dart';
import 'package:quan_ly_chi_tieu/screens/add_screen/spending_detail.dart';
import 'package:quan_ly_chi_tieu/models/spending_model.dart';
import 'package:quan_ly_chi_tieu/screens/bars/bar_chart_2.dart';
import 'package:quan_ly_chi_tieu/services/future.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final sevices = AsyncData();
  final apiService = Api();
  NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
  DateFormat format = DateFormat("dd/MM/yyyy");
  RxDouble totalBalance = 0.0.obs;
  final oneWeek = const Duration(days: 7);
  final oneMonth = const Duration(days: 30);

  Future<List<SpendingModel>> getByWeek()async{
    List<SpendingModel> snapshot = [];
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .get();
    for(var doc in data.docs ){
      String dateNow = format.format(DateTime.now());
      String date = doc['time'];
      Duration sub = format.parse(dateNow).difference(format.parse(date));
      if(sub<oneWeek && doc['type']=='-'){
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
    }
    return snapshot;
}


  Future<double> getBalance ()async{
    double balance = 0;
    var data = await sevices.getAllBill();
     for(var doc in data ){
       print(doc);
       if(doc.type=='+') {
         balance += int.parse(doc.money.toString().replaceAll(',', ''));
       }else if(doc.type=='-'){
         balance -= int.parse(doc.money.toString().replaceAll(',', ''));
       }
     }
     if (balance < 0){
       totalBalance.value =0;
     }else {
       totalBalance.value = balance;
     }
    return balance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(()=>const CategoryScreen());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              child:  Padding(
                padding: const EdgeInsets.only(top: 20, left: 20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<double>(
                      future: getBalance(),
                      builder: (context, AsyncSnapshot<double> snapshot) {
                        if(snapshot.hasData){
                          print(snapshot.data);
                          return Text(
                            "${numberFormat.format(snapshot.data)} đ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 30
                            ),
                          );
                        }else{
                          print("nodara");
                        }
                        return const Text(
                            "No data",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 30
                          ),
                        );
                      }
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(right: 25),
                    //   child: const Icon(
                    //     Icons.notifications
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              width: 360,
              height: 132,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xffe7e9ee),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ví của tôi',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      border: BorderDirectional(top: BorderSide(width: 0.8, color: Colors.grey.shade300)),
                    ),
                    child: ListTile(
                      title: const Text(
                        "Cash", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      leading: Image.network(
                        "https://cdn2.iconfinder.com/data/icons/hotel-service-32/32/wallet_finance_money_business_saving-512.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      trailing: Obx(()=>Text(
                        "${numberFormat.format(totalBalance.value)} đ",
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                      ),)
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                'Báo cáo chi tiêu',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Container(
              width: 360,
              //height: 550,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: Color(0xffe7e9ee),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: sevices.getBalanceThisWeek(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Text(
                          "${numberFormat.format(snapshot.data)} đ",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 23
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(height: 5,),
                  const Text(
                    'Tổng chi tuần này',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                  FutureBuilder<List<SubscriberSeries>>(
                    future: sevices.getBarData(),
                    builder: (context, AsyncSnapshot<List<SubscriberSeries>> snapshot){
                      if(snapshot.hasData){
                        return SubscriberChart(data: snapshot.data!);
                      }
                      return Container();
                    },
                  ),
                  const Text('Top chi tiêu tuần này'),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                      child: TopSpending())
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: 360,
              //height: 200,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Color(0xffe7e9ee),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(
                children: [
                  Text('Giao dịch gần đây'),
                  FutureBuilder<List<SpendingModel>>(
                    future: sevices.getAllBill(),//apiService.getAllBill(),
                    builder: (context,AsyncSnapshot<List<SpendingModel>> snapshot){
                      if(snapshot.hasData) {
                        List<SpendingModel> data = snapshot.data!;
                        var minLength = 0;
                        if (data.length > 8){
                          minLength = data.length - 8;
                        }
                          return Column(
                            children: [
                              for(var index = data.length -1; index >= minLength; index--)
                                ListTile(
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
                                )
                            ],
                          );
                        }
                      return Container();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

class TopSpending extends StatefulWidget {
  const TopSpending({Key? key}) : super(key: key);

  @override
  State<TopSpending> createState() => _TopSpendingState();
}

class _TopSpendingState extends State<TopSpending> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final api = Api();

  Future<List<SpendingModel>> topSpendingData ()async{
    List<SpendingModel> snapshot = [];
    var data = await FirebaseFirestore.instance
        .collection(auth.currentUser?.email.toString()??'unknow')
        .limit(3)
        .get();
    for (var doc in data.docs) {
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
  @override
  Widget build(BuildContext context) {
    AsyncData sevice = AsyncData();
    final api = Api();
    return FutureBuilder<List<SpendingModel>>(
      future: sevice.GetTopSpendingThisWeek(),
      builder: (context, AsyncSnapshot<List<SpendingModel>> snapshot){
        if(snapshot.hasData){
          List<SpendingModel> data = snapshot.data!;
          return Container(
            width: 360,
            height: 220,
            decoration: BoxDecoration(
                border: BorderDirectional(top: BorderSide(width: 0.8, color: Colors.grey.shade300))
            ),
            child:
                 Column(
                   children: [
                     for(var index=0; index< data.length; index++)
                     ListTile(
                      onTap: (){
                        Get.to(()=> SpendingDetail(spendModel: data[index],));
                      },
                      leading: Image.network(
                        data[index].icon,
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                          data[index].money,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                       subtitle: Text(
                         data[index].category
                       ),
                ),
                   ],
                 )

          );
        }
        return Container();
      },
    );
  }
}


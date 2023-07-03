import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/models/plan_model.dart';
import 'package:quan_ly_chi_tieu/screens/plan/category_plan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_chi_tieu/screens/plan/plan_detail_screen.dart';
import 'package:quan_ly_chi_tieu/services/future.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  FirebaseAuth auth = FirebaseAuth.instance;
  AsyncData sevice = AsyncData();
  NumberFormat numberFormat = NumberFormat("#,##0", "en_US");

  Stream<QuerySnapshot> snapshot(){
    String coll = auth.currentUser?.email.toString()??'unknow';
    var data = FirebaseFirestore.instance
        .collection("${coll}plan")
        .snapshots();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Hũ chi tiêu'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: snapshot(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                   List<PlanModel> data = [];
                   for(var doc in snapshot.data!.docs){
                     PlanModel model = PlanModel(
                       key: doc['keys'],
                       value: doc['value'],
                       plan: doc['plan']
                     );
                     data.add(model);
                   }
                   if(data.length == 0 ){
                     return  Center(
                       child: Container(
                         height: 50,
                         width: double.infinity,
                         child: const Center(
                           child: Text(
                             'Bạn chưa có hạn mức chi tiêu nào\n'
                                 '        Hãy thêm hạn mức mới!',
                             style: TextStyle(
                               color: Colors.black54,
                               fontSize: 15,
                             ),
                           ),
                         ),
                       ),
                     );
                   }
                   return ListView.builder(
                     physics: const NeverScrollableScrollPhysics(),
                     itemCount: data.length,
                     itemBuilder: (context, index){
                       return ListTile (
                         onTap: () async{
                           Get.to(()=>
                               PlanDetail(keys: data[index].key, value: data[index].value, plan: data[index].plan));
                         },
                         leading: Image.network(
                             data[index].value,
                           width: 37,
                           height: 37,
                           fit: BoxFit.cover,
                         ),
                         title: Text(
                           data[index].key
                         ),
                         subtitle: Text(
                           numberFormat.format(double.parse(data[index].plan))
                         ),
                         trailing: FutureBuilder<String>(
                           future: sevice.getPlanPercent(data[index].key, data[index].plan),
                           builder: (context,AsyncSnapshot<String> snapshot){
                             if(snapshot.hasData){
                               return Text(
                                   '${snapshot.data!}%',
                                 style: TextStyle(
                                   color: double.parse(snapshot.data!)<100?
                                       Colors.black: Colors.red
                                 ),
                               );
                             }
                             return CircularProgressIndicator();
                           },
                         ),
                       );
                     },
                   );
                  }
                  return const Center(
                    child: Text(
                      'Bạn chưa có hạn mức chi tiêu nào'
                          'Hãy thêm hạn mức mới',
                      style: TextStyle(
                        color: Colors.black12,
                        fontSize: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_circle, size: 40,color: Colors.green,),
                  onPressed: (){
                    Get.to(CategoryScreenPlan());
                  },
                  color: Colors.black26,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

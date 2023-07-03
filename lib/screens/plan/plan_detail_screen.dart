import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_chi_tieu/services/future.dart';

import '../../repository/api.dart';
import '../navigation_bar/navigation_bar.dart';

class PlanDetail extends StatelessWidget {
  final keys;
  final value;
  final plan;
  const PlanDetail({Key? key, required this.keys, required this.value, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final service = AsyncData();
    TextEditingController planController = TextEditingController();
    planController.text = plan;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Chi tiết hạn mức'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            child: Center(
              child: Image.network(
                value,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            padding: EdgeInsets.only(left: 40, top: 20),
              child: Row(
                children: [
                  Text('Hạn mức cho: '),
                  SizedBox(width: 30,),
                  Text(
                    keys.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.green
                    ),
                  )
                ],
              )),
          const SizedBox(height: 20,),
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                const Text('Số tiền hạn mức: '),
                const SizedBox(width: 15,),
                SizedBox(
                  height: 50,
                  width: 120,
                  child: TextFormField(
                    controller: planController,
                    keyboardType: TextInputType.number,
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.w500
                      )
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Get.defaultDialog(
                      radius: 10,
                      buttonColor: Colors.green,
                      cancelTextColor: Colors.green,
                      confirmTextColor: Colors.white,
                      middleText: "Bạn có muốn xoá không?",
                      onCancel: (){},
                      onConfirm: (){
                        service.deletePlan(keys);
                        Get.back();
                        Get.back();
                      }
                  );
                },
                child: Container(
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  margin: const EdgeInsets.only(left: 60),
                  child: const Center(
                    child: Text(
                      'Xoá hạn mức',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  await service.updatePlan(keys, planController.text, value);

                  Get.back();
                },
                child: Container(
                  width: 100,
                  height: 45,
                  margin: EdgeInsets.only(left: 70),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Center(
                    child: Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

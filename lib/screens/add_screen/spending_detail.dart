
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/screens/add_screen/spending_edit.dart';
import 'package:quan_ly_chi_tieu/models/spending_model.dart';
import 'package:get/get.dart';

import '../../repository/api.dart';
import '../home_screen/home.dart';
import '../navigation_bar/navigation_bar.dart';

class SpendingDetail extends StatelessWidget {
  final  SpendingModel spendModel;
  const SpendingDetail({Key? key, required this.spendModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = Api();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết giao dịch", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: double.infinity,
        height: 400,
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.3), width: 1),
            top: BorderSide(color: Colors.black.withOpacity(0.3), width: 1)
          )
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: Row(
                children: [
                  Image.network(
                    spendModel.icon,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      spendModel.category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 45,
                    color: Colors.yellow,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      "${spendModel.money} đ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: Colors.green
                      ),
                    ),
                  ),
                ],
              )
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 45,
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      spendModel.time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: Row(
                children: [
                  const Icon(
                    Icons.note_alt,
                    size: 45,
                    color: Colors.orangeAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      spendModel.note,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 190),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: (){
                        Get.to(()=>SpendingEdit(spendingModel: spendModel));
                      },
                      icon: const Icon(Icons.edit,),
                      iconSize: 35,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 30,),
                    IconButton(
                      onPressed: ()async{
                        Get.defaultDialog(
                          radius: 10,
                          buttonColor: Colors.green,
                          cancelTextColor: Colors.green,
                          confirmTextColor: Colors.white,
                          middleText: "Bạn có muốn xoá không?",
                          onCancel: (){},
                          onConfirm: ()async{
                            await apiService.deleteBill(spendModel.id);
                            Get.off(()=> const Navigation());
                          }
                        );
                      },
                      icon: const Icon(Icons.restore_from_trash_outlined,),
                      color: Colors.red,
                      iconSize: 35,
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}

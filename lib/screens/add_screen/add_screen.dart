import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:quan_ly_chi_tieu/screens/add_screen/category.dart';
import 'package:quan_ly_chi_tieu/services/future.dart';
import '../../repository/api.dart';
import '../navigation_bar/navigation_bar.dart';

class Add extends StatefulWidget {
  final String keys;
  final String value;
  final String type;
  const Add({Key? key, required this.keys, required this.value, required this.type}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final IdService = Api();
    final service = AsyncData();
    TextEditingController moneyController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    DateTime myDate = DateTime.now();
    dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());


    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm giao dịch", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số tiền',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 29
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: 240,
                        child: TextFormField(
                          controller: moneyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            ThousandsFormatter(),
                          ],
                          style: const TextStyle(
                              color: Colors.green,
                            fontSize: 29,
                            fontWeight: FontWeight.w500
                          ),
                          decoration: const InputDecoration(
                            hintText: '0đ',
                            hintStyle: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 29
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Get.off(()=> const CategoryScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          widget.value,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 240,
                          child: TextFormField(
                            enabled: false,
                            initialValue: widget.keys,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: ()async{
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2028)
                      );
                      if(newDate == null){
                        dateController.text = DateFormat('dd/MM/yyyy').format(myDate);
                        return;
                      }
                      myDate = newDate;
                      dateController.text = DateFormat('dd/MM/yyyy').format(myDate);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.calendar_month,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          width: 240,
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            enabled: false,
                            controller: dateController,
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ghi chú',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),
                      Container(
                        width: 240,
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                          controller: noteController,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: ()async{
              if(moneyController.text.isEmpty){
                Get.snackbar('Lỗi!', 'Số tiền của bạn không được để trống', backgroundColor: Colors.green);
              }else{
                String renId = DateTime.now().toString();
                List<String> id = [];
                id.add(renId);
                var uid = IdService.generateUUID();
                var res = await service.createBill(uid, moneyController.text, widget.type, widget.value, widget.keys, DateFormat('yyyy-MM-dd').format(myDate),myDate, noteController.text);
                if (res){
                  Get.snackbar('Thành công!', 'Bạn đã thêm một khoản chi tiêu', backgroundColor: Colors.white24);
                }else{
                  Get.snackbar('Lỗi!', 'Không thể thêm khoản chi tiêu', backgroundColor: Colors.redAccent);
                }
                Get.off(const Navigation());
              }
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 250,
                height: 50,
                color: Colors.green,
                child: const Center(
                  child: Text(
                    "XÁC NHẬN",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



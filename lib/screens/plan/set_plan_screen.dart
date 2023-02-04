import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quan_ly_chi_tieu/screens/bars/schedule.dart';

class SetPlan extends StatelessWidget {
  final String value;
  final String keys;
  const SetPlan({Key? key, required this.value, required this.keys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 200),
            child: Center(
              child: Image.network(
                  value,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30,),
          Text("Hãy đặt hạn mức chi tiêu trong tháng"),
          SizedBox(height: 30,),
          Container(
            width: 200,
            height: 30,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              onPressed: () async{
                List a =[];
                String coll = auth.currentUser?.email.toString()??'unknow';
                QuerySnapshot d= await FirebaseFirestore.instance.collection("${coll}plan")
                    .where('keys', isEqualTo: keys).get();
                for(var doc in d.docs){
                  a.add(doc);
                }
                if(a.isEmpty){
                  if(controller.text != null){
                    String coll = auth.currentUser?.email.toString()??'unknow';
                    await FirebaseFirestore.instance.collection("${coll}plan")
                        .doc(keys).set(
                        {
                          "keys": keys,
                          "value": value,
                          "plan": controller.text
                        }
                    );
                    Get.snackbar('Thành công!', 'Bạn đã thêm hạn mức chi tiêu mỗi tháng', backgroundColor: Colors.green);
                    Get.to(()=>Schedule());
                  }
                }else{
                  Get.snackbar('Lỗi!', 'Bạn đã đặt hạn mức cho khoản này rồi', backgroundColor: Colors.green);
                }

              },
              child: Text(
                "Xác nhận"
              )
          )

        ],
      ),
    );
  }
}

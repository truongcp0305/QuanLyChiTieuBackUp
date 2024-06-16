import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/api.dart';
import '../../services/future.dart';
import '../authentication/sign_in.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final service = AsyncData();
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100,),
           SizedBox(
            height: 115, width: 115,
            child:
              Image.network(
                "https://cdn0.iconfinder.com/data/icons/seo-web-4-1/128/Vigor_User-Avatar-Profile-Photo-01-512.png",
                width: 115,
                height: 115,
              )
            ),
          SizedBox(height: 20,),
          FutureBuilder<String>(
            future: service.GetUserEmail(),
              builder: (context, AsyncSnapshot<String> snapshot){
                if(snapshot.hasData){
                  return Text(
                    "${snapshot.data}",
                      style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w400
                      ),
                  );
                }else{
                  return Text(
                    "",
                    style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w400
                    ),
                  );
                }
              },

          ),
          // Text(
          //   FirebaseAuth.instance.currentUser!.email.toString(),
          //   style: const TextStyle(
          //     fontSize: 23,
          //     fontWeight: FontWeight.w400
          //   ),
          // ),
          SizedBox(height: 400,),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //   child: Container(
          //     padding: EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(15),
          //       color: Color(0xffe7e9ee)
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.person,
          //           size: 30,
          //           color: Colors.green,
          //         ),
          //         SizedBox(width: 20,),
          //         Expanded(
          //           child: Text(
          //               "Hồ sơ của tôi",
          //             style: TextStyle(
          //               fontSize: 17,
          //             ),
          //           ),
          //         ),
          //         Icon(
          //           Icons.arrow_forward_ios
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //   child: Container(
          //     padding: EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Color(0xffe7e9ee)
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.notifications_active,
          //           size: 30,
          //           color: Colors.green,
          //         ),
          //         SizedBox(width: 20,),
          //         Expanded(
          //           child: Text(
          //             "Thông báo",
          //             style: TextStyle(
          //               fontSize: 17,
          //             ),
          //           ),
          //         ),
          //         Icon(
          //           Icons.arrow_forward_ios
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //   child: Container(
          //     padding: EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Color(0xffe7e9ee)
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.settings,
          //           size: 30,
          //           color: Colors.green,
          //         ),
          //         SizedBox(width: 20,),
          //         Expanded(
          //           child: Text(
          //             "Cài đặt",
          //             style: TextStyle(
          //               fontSize: 17,
          //             ),
          //           ),
          //         ),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //   child: Container(
          //     padding: EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Color(0xffe7e9ee)
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.help_outline,
          //           size: 30,
          //           color: Colors.green,
          //         ),
          //         SizedBox(width: 20,),
          //         Expanded(
          //           child: Text(
          //             "Trợ giúp",
          //             style: TextStyle(
          //               fontSize: 17,
          //             ),
          //           ),
          //         ),
          //         Icon(
          //           Icons.arrow_forward_ios
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: GestureDetector(
              onTap: ()async{
                await FirebaseAuth.instance.signOut();
                Get.off(
                      ()=> SignIn());
                },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xffe7e9ee)
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 20,),
                    Text(
                      "Đăng xuất",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

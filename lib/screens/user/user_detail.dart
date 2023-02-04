import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/sign_in.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
              Get.off(()=> SignIn());
            },
            child: const Text("Sign out")),
      ),
    );
  }
}

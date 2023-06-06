import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    TextEditingController emailController = TextEditingController();

    void openDialog() {
      Get.dialog(
        AlertDialog(
          title: const Text('Success'),
          content: const Text('Link reset password đã được gửi đến email của bạn'),
          actions: [
            TextButton(
              child: const Text("Đóng"),
              onPressed: () {Get.back(); Get.back();} ,
            ),
          ],
        ),
      );
    }

    return  Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 120,),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    )
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green) ),
              onPressed: ()async {
                await _auth.sendPasswordResetEmail(email: emailController.text);
                openDialog();
              },
              child: const Text(
                  'Confirm'
              ),
            ),
          ],
        ),
      ),
    );
  }
}

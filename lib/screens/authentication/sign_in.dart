import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_chi_tieu/screens/authentication/register.dart';
import 'package:quan_ly_chi_tieu/screens/authentication/reset_password.dart';
import 'package:quan_ly_chi_tieu/repository/api.dart';
import '../../services/auth.dart';
import '../navigation_bar/navigation_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Authservice auth = Authservice();
  final apiService = Api();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  RxString alert = ''.obs;
  RxBool obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 120,),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: email,
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
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Obx(
                    ()=> TextFormField(
                  obscureText: obscureText.value,
                  controller: password,
                  decoration:  InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: (){
                        obscureText.value == true ?
                        obscureText.value = false:
                        obscureText.value = true;
                      },
                      icon: Icon(
                          obscureText.value == true?
                          Icons.remove_red_eye_outlined:
                          Icons.lock_outline_rounded
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                  ),

                ),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green) ),
              onPressed: ()async {
                await auth.signWithEmail(email.text, password.text);
                await apiService.login(email.text, password.text);
                var uid = FirebaseAuth.instance.currentUser?.uid;
                if(uid == null){
                  print("Tai khoan hoac mat khau khong dung");
                  alert.value = 'Username or password incorrect';
                }else{
                  await apiService.writeToFile(email.text, password.text);
                  Get.off(()=> const Navigation());
                  alert.value ='';
                }
              },
              child: const Text(
                  'Sign In'
              ),
            ),
            const SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(color: Colors.green, fontSize: 14),
                        recognizer: TapGestureRecognizer()
                           ..onTap = (){Get.to(()=> const Register());}
                    )
                  ]
              ),
            ),
            const SizedBox(
              height: 30,
            ),
             RichText(
                text:  TextSpan(
                  text: "Forgot password?",
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                  recognizer: TapGestureRecognizer()
                    ..onTap = (){Get.to(()=> const ResetPassword());}
                )
            ),
            const SizedBox(height: 40,),
            Obx(()=> Center(
              child: Text(
                alert.value,
                style: const TextStyle(color: Colors.red),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
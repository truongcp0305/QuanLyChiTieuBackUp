import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth.dart';
import '../navigation_bar/navigation_bar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Authservice auth = Authservice();
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController comfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: email,
                      validator: (_) =>
                          email.text.isEmpty ? 'Enter an email' : null,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      validator: (_) => password.text.length <= 6
                          ? 'Password must have 6+ chars'
                          : null,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: comfirmPassword,
                      obscureText: true,
                      validator: (_) => comfirmPassword.text != password.text
                          ? 'Password is not match'
                          : null,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: 'Re enter your password',
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  dynamic result =
                      await auth.registerWithEmail(email.text, password.text);
                  if (result == null) {
                    print("can not register");
                  }
                  Get.to(() => const Navigation());
                } else {
                  Get.defaultDialog(title: 'Warnning', middleText: 'Email has used', backgroundColor: Colors.white);
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/authentication/sign_in.dart';
import '../screens/navigation_bar/navigation_bar.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    Stream<User?> getUser(){
      return auth.authStateChanges();
    }

    return StreamBuilder<User?>(
        stream: getUser(),
        builder: (context, AsyncSnapshot<User?>snapshot) {
          if (snapshot.hasData){
            var uid = snapshot.data?.uid;
            if(uid != null){
              return const Navigation();
            }else{
              return const SignIn();
            }
          }else{
            return const SignIn();
          }
          return const SignIn();
        }
    );
  }
}
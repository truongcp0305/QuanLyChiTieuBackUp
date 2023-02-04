import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signWithEmail(String email, String password) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmail(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      var emailcreate = user?.email;;
    }catch(e){
      return null;
    }
  }

  Future SignOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      return null;
    }
  }
}

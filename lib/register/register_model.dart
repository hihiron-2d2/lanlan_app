import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RegisterModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  void setEmail(String? email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String? password) {
    this.password = password;
    notifyListeners();
  }

  Future signUp() async {
    email = emailController.text;
    password = passwordController.text;

    if (email != null && password != null) {
      //Firebase authの追加
      final userCredential = await  FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;
        
        //Firestoreに追加
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        
        await doc.set({
          'uid': uid,
          'email': email,
        });
      }
    }
  }
}


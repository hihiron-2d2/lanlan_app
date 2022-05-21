import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/domain/folder.dart';

class LoginModel extends ChangeNotifier {
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

  Future login() async {
    email = emailController.text;
    password = passwordController.text;
    //Login
    if (email != null && password != null) {
      //Login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!
      );

      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser?.uid;
    }
  }
}


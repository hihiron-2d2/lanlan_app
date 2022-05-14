import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future signUp() async {
    email = emailController.text;
    password = passwordController.text;

    //Login

  }
}


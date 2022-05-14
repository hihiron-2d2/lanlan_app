import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/domain/folder.dart';

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

    //Firestoreの追加
    // await FirebaseFirestore.instance.collection('folders').doc(folder.id).update({
    //   'title': title,
    // });
  }
}


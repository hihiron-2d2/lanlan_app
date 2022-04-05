import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddFolderModel extends ChangeNotifier{
  String? title;

  Future addFolder() async {
    if(title == null || title == "") {
      throw 'no folder name';
    }

    ///Firestoreの追加
    await FirebaseFirestore.instance.collection('folders').add({
      'title': title,
    });
  }
}

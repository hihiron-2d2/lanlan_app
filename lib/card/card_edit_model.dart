import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanlan_app/domain/card.dart';

class EditCardModel extends ChangeNotifier{
  final Flipcard flipcard;
  EditCardModel(this.flipcard) {
    frontWordController.text = flipcard.frontWord ?? 'no card';
    backWordController.text = flipcard.backWord ?? 'no card';
  }

  final frontWordController = TextEditingController();
  final backWordController = TextEditingController();

  String? frontWord;
  String? backWord;

  void setFrontWord(String? frontWord) {
    this.frontWord = frontWord;
    notifyListeners();
  }

  void setBackWord(String? backWord) {
    this.backWord = backWord;
    notifyListeners();
  }


  bool isUpdated() {
    return frontWord != null || backWord != null;
  }

  bool isDeleted() {
    return frontWord != null || backWord != null;
  }

  static final folderRef = FirebaseFirestore.instance.collection('folders');

  Future update(String? id) async {
    frontWord = frontWordController.text;
    backWord = backWordController.text;

    //Firestoreの追加
    await folderRef.doc(id).collection('flipcards').doc(flipcard.id).update({
      'frontWord': frontWord,
      'backWord': backWord,
    });
  }

// Future delete(String? id) {
//   return folderRef.doc(id).collection('flipcards').doc(flipcard.id).delete();
// }
}


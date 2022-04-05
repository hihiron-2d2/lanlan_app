// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/domain/card.dart';
import 'package:lanlan_app/main.dart';

class CardListModel extends ChangeNotifier{
  List<Flipcard>? flipcardList;

  String? frontWord;
  String? backWord;

  static final folderRef = FirebaseFirestore.instance.collection('folders');

  void fetchCardList(String? id) async {
    final QuerySnapshot snapshot = await folderRef.doc(id).collection('flipcards').get();

    final List<Flipcard>? flipcard = snapshot.docs.map((DocumentSnapshot document) {
      Map<String?, dynamic> data = document.data()! as Map<String?, dynamic>;
      final String? id = document.id;
      final String? frontWord = data['frontWord'];
      final String? backWord = data['backWord'];
      return Flipcard(id, frontWord, backWord);
    }).toList();

    flipcardList = flipcard;
    notifyListeners();
  }

  Future add(String? id) async {
    if (frontWord == null || frontWord == "") {
      throw 'no word';
    }

    if (backWord == null || backWord!.isEmpty) {
      throw'no word';
    }

    logger.info('----------------- $frontWord');
    logger.info('----------------- $backWord');


    await folderRef.doc(id).collection('flipcards').add({
      'frontWord': frontWord,
      'backWord': backWord,
    });

    await folderRef.doc(id).collection('flipcards').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        logger.info('りんご');
        /// usersコレクションのドキュメントIDを取得する
        logger.info(doc.id);
        /// 取得したドキュメントIDのフィールド値nameの値を取得する
        logger.info(doc.get('frontWord'));
        logger.info(doc.get('backWord'));
      });
    });
  }

  Future delete({required String? id,required Flipcard flipcard}) {
    logger.info('おっぱい$id');
    logger.info(flipcard.id);
    return folderRef.doc(id).collection('flipcards').doc(flipcard.id).delete();
  }

// Future dragAndDrop(int oldIndex, int newIndex, String? id, Flipcard flipcard, CardListModel model) async {
//   if (oldIndex < newIndex) {
//     newIndex -= 1;
//   }
//   Flipcard flipcard = flipcard.removeAt(oldIndex);
//
//   await flipcard.insert(newIndex, Flipcard);
//   notifyListeners();
// }
}


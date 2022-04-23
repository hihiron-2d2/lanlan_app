// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/domain/card.dart';
import 'package:lanlan_app/domain/memo.dart';
import 'package:lanlan_app/main.dart';

class MemoListModel extends ChangeNotifier{
  List<Memo>? memoList;
  Flipcard? flipcard;
  String? memo;

  static final folderRef = FirebaseFirestore.instance.collection('folders');

  void fetchMemoList({required String? id, required Flipcard flipcard}) async {
    final QuerySnapshot snapshot = await folderRef.doc(id).collection('flipcards').doc(flipcard.id).collection("memo").get();

    await folderRef.doc(id).collection('flipcards').doc(flipcard.id).collection("memo").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        logger.info('りんご');
        /// usersコレクションのドキュメントIDを取得する
        logger.info(doc.id);
        /// 取得したドキュメントIDのフィールド値nameの値を取得する
        logger.info(doc.get('memo'));
      });
    });

    final List<Memo>? memo = snapshot.docs.map((DocumentSnapshot document) {
      Map<String?, dynamic> data = document.data()! as Map<String?, dynamic>;
      final String? id = document.id;
      final String? memo = data['memo'];
      return Memo(id, memo);
    }).toList();

    memoList = memo;
    notifyListeners();
  }

  Future add({required String? id, required Flipcard flipcard}) async {
    if (memo == null || memo == "") {
      throw 'no word';
    }

    logger.info('----------------- $memo');

    await folderRef.doc(id).collection('flipcards').doc(flipcard.id).collection("memo").add({
      'memo': memo,
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

  Future delete({required String? id,required Flipcard flipcard, required Memo memo}) {
    logger.info('apple$id');
    logger.info(flipcard.id);
    return folderRef.doc(id).collection('flipcards').doc(flipcard.id).collection("memo").doc(memo.id).delete();
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



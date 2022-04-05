import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/domain/folder.dart';

///このファイルでFirebase連携させている
class  FolderListModel extends ChangeNotifier{
  List<Folder>? folders; ///null許容している、ここでFolderを入れてあげる

  void fetchFolderList() async {  ///fetchFolderListは関数
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('folders').get();

    final List<Folder>? folders = snapshot.docs.map((DocumentSnapshot document) {  ///snapshotに値が入る→mapでDocumentSnapshot型からFolderに変更する
      Map<String?, dynamic> data = document.data()! as Map<String?, dynamic>;  ///String dynamicのデータにする
      final String? id = document.id;
      final String? title = data['title'];
      return Folder(id, title);
    }).toList();

    this.folders = folders;
    notifyListeners(); ///ここが終了ポイント
  }

  Future delete(Folder folder) {
    return FirebaseFirestore.instance.collection('folders').doc(folder.id).delete();
  }
}
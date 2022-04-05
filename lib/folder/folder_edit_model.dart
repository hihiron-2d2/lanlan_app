import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/domain/folder.dart';

class EditFolderModel extends ChangeNotifier{
  final Folder folder;
  EditFolderModel(this.folder) {
    titleController.text = folder.title ?? 'no folder';
  }

  final titleController = TextEditingController();

  String? title;

  void setTitle(String? title) {
    this.title = title;
    notifyListeners();
  }


  bool isUpdated() {
    return title != null;
  }

  Future update() async {
    title = titleController.text;

    //Firestoreの追加
    await FirebaseFirestore.instance.collection('folders').doc(folder.id).update({
      'title': title,
    });
  }
}

import 'package:flutter/material.dart';
import 'package:lanlan_app/folder/folder_add_model.dart';
import 'package:provider/provider.dart';

class AddFolderPage extends StatelessWidget {
  const AddFolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddFolderModel>(
      create: (_) => AddFolderModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAD5A6),
          title: const Text("add new folder"),
        ),
        body: Center(
          child: Consumer<AddFolderModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'folder Name',
                    ),
                    onChanged: (text) {
                      //todo取得したtextを使う
                      model.title = text;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(onPressed: () async {
                    //追加の処理
                    try {
                      await model.addFolder();
                      Navigator.of(context).pop(true);
                    } catch (e){
                      final snackBar = SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                    child: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFFAD5A6), //ボタンの背景色
                    ),
                  ),
                ],),
            );
          }),
        ),
      ),
    );
  }
}

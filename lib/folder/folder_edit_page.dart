import 'package:flutter/material.dart';
import 'package:lanlan_app/domain/folder.dart';
import 'package:lanlan_app/folder/folder_edit_model.dart';
import 'package:provider/provider.dart';

class EditFolderPage extends StatelessWidget {
  final Folder folder;
  // ignore: use_key_in_widget_constructors
  const EditFolderPage(this.folder);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditFolderModel>(
      create: (_) => EditFolderModel(folder),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: const Color(0xFFFAD5A6),
            title: Container(
                margin: const EdgeInsets.only(top:20, left:5),
                child: const Text(

                  "Edit Page",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                )),
          ),
        ),
        body: Center(
          child: Consumer<EditFolderModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                  controller: model.titleController,
                  decoration: const InputDecoration(
                    hintText: 'folder Name',
                  ),
                  onChanged: (text) {
                    model.setTitle(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: model.isUpdated()
                      ? ()  async {
                    //追加の処理
                    try {
                      await model.update();
                      Navigator.of(context).pop(model.title);
                    } catch (e){
                      final snackBar = SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } : null, //なんでここにnullがつくんだ？
                  child: const Text('update'),
                ),
              ],),
            );
          }),
        ),
      ),
    );
  }
}

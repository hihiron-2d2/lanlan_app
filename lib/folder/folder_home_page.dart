import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lanlan_app/card/card_home_page.dart';
import 'package:lanlan_app/domain/folder.dart';
import 'package:lanlan_app/folder/folder_add_page.dart';
import 'package:lanlan_app/folder/folder_edit_page.dart';
import 'package:lanlan_app/folder/folder_home_model.dart';
import 'package:lanlan_app/login/login_page.dart';
import 'package:lanlan_app/main.dart';
import 'package:provider/provider.dart';

class FolderHomePage extends StatelessWidget {
  const FolderHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FolderListModel>(
      create: (_) => FolderListModel()..fetchFolderList(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFFFAD5A6),
            title: const Text(
              "My folder",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
              onPressed: () async {
                //画面遷移
                if (FirebaseAuth.instance.currentUser != null) {
                  print('ログインしている');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(),
                      fullscreenDialog: true,
                    ),
                  );
                } else {
                  print('ログインしていない');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(),
                      fullscreenDialog: true,
                    ),
                  );
                }
              },
                icon: const Icon(Icons.person),),
            ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<FolderListModel>(builder: (context, model, child) { ///modelの後にこのコードが読まれる
              final List<Folder>? folder = model.folders; ///List<folder>の型は決まっている

              if (folder == null) {
                return const CircularProgressIndicator();  ///Loadingしているのがreturnされる　
              }

              final List<Widget> widgets = folder.map(  ///mapで囲んでListTileに変換する
                    (folder) => Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          //編集画面に遷移する
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFolderPage(folder),
                            ),
                          );

                          if (title != null){
                            final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF8fbc8f),
                              content: Text('Edited $title'),
                            );
                            model.fetchFolderList();
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        backgroundColor: const Color(0xFF8fbc8f),
                        foregroundColor: Colors .white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await showDeleteDialog(context, folder, model);
                        },
                        backgroundColor: const Color(0xFFf08080),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        folder.title ?? 'no folder',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: const Icon(Icons.folder),
                      trailing: const Icon(Icons.menu),
                      onTap: () {
                        logger.info('push');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context){
                            return CardHomePage( id: folder.id);},),);
                      },
                    ),
                  ),
                ),
              )
                  .toList();
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                children: widgets,
              );
            }),
          ),
        ),
        floatingActionButton: Consumer<FolderListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFolderPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added){
                final snackBar = SnackBar(
                  backgroundColor: Colors.lightGreen,
                  content: Text('Added the folder'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                model.fetchFolderList();
              }
            },
            tooltip: 'Increment',
            backgroundColor: const Color(0xFFFAD5A6),
            child: const Icon(Icons.create_new_folder),
          );
        }
        ),
      ),
    );
  }

  Future showDeleteDialog(
      BuildContext context,
      Folder folder,
      FolderListModel model
      ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirmed deletion"),
            content: Text("Do you want to delete『${folder.title}』?"),
            actions: [
              CupertinoDialogAction(
                  child: const Text('Cancel'),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                child: const Text('OK'),
                //modelで削除
                onPressed: () async {
                  await model.delete(folder);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    backgroundColor: const Color(0xFFf08080),
                    content: Text('Deleted ${folder.title}'),
                  );
                  model.fetchFolderList();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              )
            ],
          );
        });
  }
}


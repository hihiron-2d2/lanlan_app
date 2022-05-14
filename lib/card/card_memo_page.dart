// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lanlan_app/card/add_memo_page.dart';
import 'package:lanlan_app/card/card_memo_model.dart';
import 'package:lanlan_app/domain/card.dart';
import 'package:lanlan_app/domain/memo.dart';
import 'package:lanlan_app/main.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MemoCardPage extends StatelessWidget {
  String? id;
  Flipcard flipcard;
  MemoCardPage({Key? key, required this.id, required this.flipcard,}) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoListModel>(
      create: (_) => MemoListModel()..fetchMemoList(id: id, flipcard: flipcard),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAD5A6),
          title: const Text(
            "My Memo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<MemoListModel>(builder: (
              context,
              model,
              child,
            ) {
              final List<Memo>? memo = model.memoList;

              if (memo == null) {
                return const CircularProgressIndicator();
              }

              final List<Widget> widgets = memo
                  .map(
                    ///mapで囲んでListTileに変換する
                    (memo) => Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.30,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await showDeleteDialog(
                                context: context,
                                flipcard: flipcard,
                                memo: memo,
                                id: id,
                                model: model,
                              );
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
                            memo.memo ?? 'no memo',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList();
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(25.0),
                children: widgets,
              );
            }),
          ),
        ),
        floatingActionButton: Consumer<MemoListModel>(builder: (
          context,
          model,
          child,
           ) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMemoPage(id: id, flipcard: flipcard),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.lightGreen,
                  content: const Text('Added your card'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                model.fetchMemoList(id: id, flipcard: flipcard);
              }
            },
            tooltip: 'Increment',
            backgroundColor: const Color(0xFFFAD5A6),
            child: const Icon(Icons.add),
          );
        }),
     ),
    );
  }
}

Future showDeleteDialog({
  required BuildContext context,
  required Flipcard flipcard,
  required Memo memo,
  required String? id,
  required MemoListModel model,
}) {
  ///TODO:ログ吐いて引数の値を確認して、必要な値が取れているか確認する事！！！！
  logger.info('folders / $id');
  logger.info('folders / $id / flipcards / ${flipcard.id} / memo / ${memo.id}');
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmed deletion"),
          content: Text(
              "Do you want to delete『${memo.memo}』?"),
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
                await model.delete(id: id, flipcard: flipcard, memo: memo);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: const Color(0xFFf08080),
                  content: Text(
                      'Deleted ${memo.memo}'),
                );
                model.fetchMemoList(id: id, flipcard: flipcard);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            )
          ],
        );
      });
}

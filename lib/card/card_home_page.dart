import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lanlan_app/card/card_add_page.dart';
import 'package:lanlan_app/card/card_edit_page.dart';
import 'package:lanlan_app/card/card_home_model.dart';
import 'package:lanlan_app/card/card_memo_page.dart';
import 'package:lanlan_app/domain/card.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';

import '../main.dart';

// ignore: must_be_immutable
class CardHomePage extends StatelessWidget {
  String? id;

  CardHomePage({
    Key? key,
    required this.id,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CardListModel>(
      create: (_) => CardListModel()..fetchCardList(id),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAD5A6),
          title: const Text(
            "My Card",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<CardListModel>(builder: (
              context,
              model,
              child,
            ) {
              final List<Flipcard>? flipcard = model.flipcardList;
              flipcard?.forEach((element) {
                logger.info(element.id);
                logger.info(element.frontWord);
                logger.info(element.backWord);
              });

              if (flipcard == null) {
                return const CircularProgressIndicator();
              }

              final List<Widget> widgets = flipcard
                  .map(
                    ///mapで囲んでListTileに変換する
                    (flipcard) => Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.80,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              //編集画面に遷移する
                              final String? frontWord = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditCardPage(flipcard, id: id),
                                ),
                              );

                              if (frontWord != null) {
                                final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF8fbc8f),
                                  content: Text('Edited $frontWord'),
                                );
                                model.fetchCardList(id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            backgroundColor: const Color(0xFF8fbc8f),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              logger.info('success');
                              logger.info(
                                  'folders / $id / flipcards / ${flipcard.id}');
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemoCardPage(
                                    id: id,
                                    flipcard: flipcard,
                                  ),
                                ),
                              );
                            },
                            backgroundColor: const Color(0xFFb0e0e6),
                            foregroundColor: Colors.white,
                            icon: Icons.note_add,
                            label: 'Memo',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              await showDeleteDialog(
                                context: context,
                                flipcard: flipcard,
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
                        elevation: 0.0,
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0, bottom: 5.0),
                        color: const Color(0x00000000),
                        ///フリップカード始
                        child: FlipCard(
                          direction: FlipDirection.HORIZONTAL,
                          speed: 500,
                          onFlipDone: (status) {
                            //print(status);
                          },
                          front: 
                          // Container(
                          //   height: 180,
                          //   width: 350,
                          //   decoration: const BoxDecoration(
                          //     color: Color(0xFFDAE9E4),
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(12.0)),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       FloatingActionButton(
                          //         onPressed: () async {
                          //           //画面遷移
                          //           await Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) => AddCardPage(id: id),
                          //               fullscreenDialog: true,
                          //             ),
                          //           );
                          //         },
                          //         tooltip: 'Voice',
                          //         backgroundColor: const Color(0xFFb0e0e6),
                          //         child: const Icon(Icons.settings_voice_rounded),
                          //       ),
                          //       const SizedBox(width: 50),
                          //       Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: <Widget>[
                          //           Text(
                          //             flipcard.frontWord ?? 'no card',
                          //             style: const TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 20,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          //   ),
                          Stack(
                            children: [
                              Column(
mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               Container(color : Colors.red,child: const Text('テキスト'),),
                              ],
                              ),
                              Column(children : [
                                Expanded(child : Container(color: Colors.blue)),
                                Padding(padding : const EdgeInsets.only(left : 10,bottom : 10),child :Row(children : [
                                  FloatingActionButton(
                                  onPressed: () async {
                                    //画面遷移
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddCardPage(id: id),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  tooltip: 'Voice',
                                  backgroundColor: const Color(0xFFb0e0e6),
                                  child: const Icon(Icons.settings_voice_rounded),
                                ),
                                Expanded(child : Container(color : Colors.yellow)),
                                ]),),
                              ]),
                            ],
                          ),
                          back: Container(
                            height: 180,
                            width: 350,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDAE9E4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  flipcard.backWord ?? 'no card',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///フリップカード終
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
        floatingActionButton: Consumer<CardListModel>(builder: (
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
                  builder: (context) => AddCardPage(id: id),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.lightGreen,
                  content: const Text('Added your card'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                model.fetchCardList(id);
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
  required String? id,
  required CardListModel model,
}) {
  ///TODO:ログ吐いて引数の値を確認して、必要な値が取れているか確認する事！！！！
  logger.info('folders / $id');
  logger.info('folders / $id / flipcards / ${flipcard.id}');
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmed deletion"),
          content: Text(
              "Do you want to delete『${flipcard.frontWord}』and『${flipcard.backWord}』?"),
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
                await model.delete(id: id, flipcard: flipcard);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: const Color(0xFFf08080),
                  content: Text(
                      'Deleted ${flipcard.frontWord} and ${flipcard.backWord}'),
                );
                model.fetchCardList(id);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            )
          ],
        );
      });
}

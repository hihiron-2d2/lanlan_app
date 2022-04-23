import 'package:flutter/material.dart';
import 'package:lanlan_app/card/card_memo_model.dart';
import 'package:lanlan_app/domain/card.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddMemoPage extends StatelessWidget {
  String? id;
  Flipcard flipcard;
  AddMemoPage({Key? key,required this.id, required this.flipcard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoListModel>(
      create: (_) => MemoListModel(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: const Color(0xFFFAD5A6),
            title: Container(
                margin: const EdgeInsets.only(top:20, left:20),
                child: const Text(
                  "Add Memo",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
          ),
        ),
        body: Center(
          child: Consumer<MemoListModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Memo',
                    ),
                    onChanged: (text) {
                      //todo　取得したtextを使う
                      model.memo = text;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(onPressed: () async {
                    //追加の処理
                    try {
                      await model.add(id: id, flipcard: flipcard);
                      Navigator.of(context).pop(true);
                    } catch (e){
                      final snackBar = SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }, child: const Text('Add'),
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
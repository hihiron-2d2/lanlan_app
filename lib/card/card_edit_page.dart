import 'package:flutter/material.dart';
import 'package:lanlan_app/card/card_edit_model.dart';
import 'package:lanlan_app/domain/card.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditCardPage extends StatelessWidget {
  String? id;
  final Flipcard flipcard;
  EditCardPage(this.flipcard, {Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditCardModel>(
      create: (_) => EditCardModel(flipcard),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAD5A6),
          title: const Text(
            "Edit Page",
          ),
        ),
        body: Center(
          child: Consumer<EditCardModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                  controller: model.frontWordController,
                  decoration: const InputDecoration(
                    hintText: 'Front word name',
                  ),
                  onChanged: (text) {
                    model.setFrontWord(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: model.backWordController,
                  decoration: const InputDecoration(
                    hintText: 'Back word name',
                  ),
                  onChanged: (text) {
                    model.setBackWord(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: model.isUpdated()
                      ? ()  async {
                    //追加の処理
                    try {
                      await model.update(id);
                      Navigator.of(context).pop(model.frontWord);
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

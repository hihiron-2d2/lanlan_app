import 'package:flutter/material.dart';
import 'package:lanlan_app/register/register_model.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAD5A6),
          title: const Text(
            "Signup",
          ),
        ),
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                  controller: model.emailController,
                  decoration: const InputDecoration(
                    hintText: 'email',
                  ),
                  onChanged: (text) {
                    model.setEmail(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: model.passwordController,
                  decoration: const InputDecoration(
                    hintText: 'password',
                  ),
                  onChanged: (text) {
                    model.setPassword(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: ()  async {
                    //追加の処理
                    try {
                      await model.signUp();
                      //Navigator.of(context).pop(model.title);
                    } catch (e){
                      final snackBar = SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Register'),
                ),
              ],),
            );
          }),
        ),
      ),
    );
  }
}

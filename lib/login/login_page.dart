import 'package:flutter/material.dart';
import 'package:lanlan_app/login/login_model.dart';
import 'package:lanlan_app/register/register_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAD5A6),
          title: const Text(
            "login",
          ),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
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
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: ()  async {
                    //追加の処理
                    try {
                      await model.login();
                      Navigator.of(context).pop();
                    } catch (e){
                      final snackBar = SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    //画面遷移
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: const Text('Signup'),
                ),
              ],),
            );
          }),
        ),
      ),
    );
  }
}

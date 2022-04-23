import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lanlan_app/folder/folder_home_page.dart';
import 'package:simple_logger/simple_logger.dart';
import 'firebase_options.dart';

final logger = SimpleLogger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lanlan',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const FolderHomePage(),
    );
  }
}





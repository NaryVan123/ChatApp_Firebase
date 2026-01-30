import 'package:chat_app_using_firebase/auth/login_or_register.dart';
import 'package:chat_app_using_firebase/firebase_options.dart';
import 'package:chat_app_using_firebase/pages/all_chat_page.dart';
import 'package:chat_app_using_firebase/utils/app_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isLoggedIn = await AppPrefs.isLoggedIn();
  final String? username = await AppPrefs.getUserName();

  runApp(MyApp(isLogin: isLoggedIn, name: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLogin, required this.name});
  final bool isLogin;
  final String? name;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLogin ? AllChatsPage(username: name) : LoginOrRegister(),
    );
  }
}

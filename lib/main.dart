import 'package:flutter/material.dart';
import 'package:mebook/auth/login.dart';
import 'package:provider/provider.dart';

import 'providers/loginController.dart';
import 'providers/signupController.dart';
import 'providers/uploadController.dart';
import 'providers/homeController.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => HomeController()),
          ChangeNotifierProvider(builder: (_) => LoginController()),
          ChangeNotifierProvider(builder: (_) => SignupController()),
          ChangeNotifierProvider(builder: (_) => UploadController()),
        ],
        child: MaterialApp(
          title: 'Material Card Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xFF4872FF),
              accentColor: Colors.amber[800],
              brightness: Brightness.dark),
          home: Login(/* user: null, userModel: null, */),
        ));
  }
}

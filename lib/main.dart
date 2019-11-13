import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {




  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'PayParking Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: SignInPage(),
    );
  }
}
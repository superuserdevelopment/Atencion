import 'package:e_learning/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'atención',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF8015E8),
          accentColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Circular',
              bodyColor: Colors.white,
              displayColor: Colors.white),
          primaryColorDark: Color(0xFF333333),
          //canvasColor: Color(0xFF333333),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage());
  }
}

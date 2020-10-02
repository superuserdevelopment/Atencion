import 'package:e_learning/pages/cart.dart';
import 'package:e_learning/pages/home_page.dart';
import 'package:e_learning/pages/loading.dart';
import 'package:e_learning/pages/login_page.dart';
import 'package:e_learning/services/auth.dart';
import 'package:e_learning/services/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthenticationService().user,
      child: MaterialApp(
        title: 'atención',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF8015E8),
          accentColor: Color(0xFF40E0D0),
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Circular',
              bodyColor: Colors.white,
              displayColor: Colors.white),
          primaryColorDark: Color(0xFF333333),
          primaryColorLight: Color(0xFFFADF12),
          //canvasColor: Color(0xFF333333),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/wrapper',
        routes: {
          '/': (context) => LoadingScreen(),
          '/home': (context) => HomePage(),
          '/signin': (context) => LoginPage(),
          '/wrapper': (context) => Wrapper(),
          '/cart': (context) => Cart(),
        },
      ),

      //home: HomePage()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_learning/pages/home_page.dart';
import 'package:e_learning/pages/login_page.dart';
import 'package:e_learning/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if (user != null) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}

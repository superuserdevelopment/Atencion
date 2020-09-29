import 'package:e_learning/pages/account_fragment.dart';
import 'package:e_learning/pages/courses_fragment.dart';
import 'package:e_learning/pages/landing_fragment.dart';
import 'package:e_learning/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService _auth = AuthenticationService();
  final List<Widget> _fragments = [
    Landing_Fragment(),
    CoursesFragment(),
    AccountFragment()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: SafeArea(
          child: _fragments[_currentIndex],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 20),
          child: CustomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            iconSize: 30.0,
            elevation: 10.0,
            currentIndex: _currentIndex,
            strokeColor: Colors.white,
            borderRadius: Radius.circular(15.0),
            selectedColor: Theme.of(context).primaryColorLight,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            unSelectedColor: Colors.white,
            isFloating: true,
            items: [
              CustomNavigationBarItem(
                icon: Icons.home,
              ),
              CustomNavigationBarItem(
                icon: Icons.lightbulb,
              ),
              CustomNavigationBarItem(
                icon: Icons.account_circle,
              ),
            ],
          ),
        ));
  }
}

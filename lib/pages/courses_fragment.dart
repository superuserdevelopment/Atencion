import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class CoursesFragment extends StatefulWidget {
  @override
  _CoursesFragmentState createState() => _CoursesFragmentState();
}

class _CoursesFragmentState extends State<CoursesFragment> {
  List<String> categories = ['In Progress', 'Completed'];
  int _selectedFrag = 0;
  Widget categoriesBuildBody(BuildContext ctxt, int index) {
    Color selected = index == _selectedFrag
        ? Theme.of(context).accentColor
        : Theme.of(context).primaryColorLight;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: selected,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: new Text(
              categories[index],
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark, fontSize: 20.0),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'My Courses',
                style: TextStyle(fontSize: 40.0, fontFamily: 'Circular-Medium'),
              ),
              SizedBox(
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    categoriesBuildBody(context, 0),
                    categoriesBuildBody(context, 1),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

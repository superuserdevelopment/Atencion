import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/courses.dart';
import 'package:e_learning/models/user.dart';
import 'package:e_learning/services/database.dart';
import 'package:e_learning/widget_assets/courses_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CoursesFragment extends StatefulWidget {
  @override
  _CoursesFragmentState createState() => _CoursesFragmentState();
}

class _CoursesFragmentState extends State<CoursesFragment> {
  List<String> categories = ['In Progress', 'Completed'];
  int _selectedFrag = 0;
  List cart = new List();
  final DatabaseService _databaseService = new DatabaseService();
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
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Logo(),
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
              Expanded(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('Users')
                      .document(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      cart = snapshot.data['enrolledCourses'];
                    }
                    if (cart.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 50.0),
                          child: Card(
                            elevation: 10.0,
                            color: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              child: Text(
                                'It\'s pretty lonely in here...\nadd some courses to continue',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 30.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return StreamBuilder(
                      stream:
                          Firestore.instance.collection('Courses').snapshots(),
                      builder: (context, snapshot) {
                        List<Course> courses = new List<Course>();
                        if (!snapshot.hasData) {
                          return Text(
                            'Loading, Please Wait',
                            style: TextStyle(color: Colors.white),
                          );
                        }
                        //print(snapshot.data.documents[0]['title'].toString());
                        snapshot.data.documents.forEach((document) {
                          // print(document['title']);
                          // print('Document ID:' + document.documentID);
                          // if (!courseUids.contains(document.documentID)) {
                          //   // courseUids.add(document.documentID);
                          //   // courses.add(Course(
                          //   //   uid: document.documentID,
                          //   //   name: document['title'],
                          //   // ));
                          // }
                          //courseUids.add(document.documentID);
                          if (cart.contains(document.documentID.toString()) &&
                              document['title'] != null &&
                              document['graphicUrl'] != null &&
                              document['weeks'] != null) {
                            courses.add(Course(
                              uid: document.documentID,
                              name: document['title'],
                              graphicUrl: document['graphicUrl'],
                              week: document['weeks'],
                            ));
                          }
                        });
                        return CourseCardList(
                          courses: courses,
                          showSideMenu: false,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}

Widget Logo() {
  return Container(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'My Courses',
        style: TextStyle(
            fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      SvgPicture.asset(
        'assets/vectors/line2.svg',
        semanticsLabel: 'Line',
        width: 230.0,
      ),
      SizedBox(
        height: 8.0,
      ),
      // Text(
      //   'The learning app',
      //   style: TextStyle(
      //       fontSize: 24.0,
      //       fontWeight: FontWeight.bold,
      //       color: Theme.of(context).primaryColor),
      // ),
    ],
  ) //App Logo,
      );
}

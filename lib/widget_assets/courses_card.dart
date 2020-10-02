import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/courses.dart';
import 'package:e_learning/models/user.dart';
import 'package:e_learning/services/database.dart';
import 'package:e_learning/widget_assets/message_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CourseCard extends StatefulWidget {
  final Course courses;
  bool showSideMenu = true;
  CourseCard({this.courses, this.showSideMenu});
  @override
  _CourseCardState createState() =>
      _CourseCardState(course: courses, showSideMenu: showSideMenu);
}

class _CourseCardState extends State<CourseCard> {
  final DatabaseService _databaseService = new DatabaseService();
  bool showSideMenu = true;
  Course course;
  _CourseCardState({this.course, this.showSideMenu});
  IconData bookmark = Icons.bookmark_outline;
  IconData add = Icons.shopping_cart_outlined;
  int progress;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream:
          Firestore.instance.collection('Users').document(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List wishlist = snapshot.data['wishlistedCourses'];
          progress = snapshot.data['progress'][course.uid];
          if (wishlist.contains(course.uid)) {
            bookmark = Icons.bookmark;
          } else {
            bookmark = Icons.bookmark_outline;
          }
          List cart = snapshot.data['cart'];
          if (cart.contains(course.uid)) {
            add = Icons.shopping_cart;
          } else {
            add = Icons.shopping_cart_outlined;
          }
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              //elevation: 10.0,
              color: Colors.transparent,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            height: 170.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: new Radius.circular(15.0),
                                ),
                                color: Theme.of(context).primaryColorLight,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 20.0,
                                      spreadRadius: 5.0,
                                      offset: Offset(0, 10),
                                      color: Colors.grey[900]),
                                ]),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.network(
                          course.graphicUrl,
                          semanticsLabel: 'A shark?!',
                          width: 2000.0,
                          height: 200.0,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                  //Content Container
                  Container(
                    //height: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: new Radius.circular(15.0),
                        ),
                        color: Theme.of(context).accentColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20.0,
                              spreadRadius: 5.0,
                              offset: Offset(0, 10),
                              color: Colors.grey[900]),
                        ]),

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                course.name,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 18.0),
                              )),
                              //Wishlist and add to cart columns
                              showSideMenu
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            bookmark,
                                            color: Colors.red[400],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (bookmark ==
                                                  Icons.bookmark_outline) {
                                                _databaseService.updateWishlist(
                                                    user.uid, course.uid);
                                                bookmark = Icons.bookmark;
                                              } else {
                                                _databaseService.removeWishlist(
                                                    user.uid, course.uid);
                                                bookmark =
                                                    Icons.bookmark_outline;
                                              }
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(add,
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                          onPressed: () {
                                            //add the course to cart
                                            setState(() {
                                              if (add ==
                                                  Icons
                                                      .shopping_cart_outlined) {
                                                _databaseService.updateCart(
                                                    user.uid, course.uid);
                                                add = Icons.shopping_cart;
                                                showAlertDialog(
                                                    'Added to Cart',
                                                    '\"' +
                                                        course.name +
                                                        '\"\nhas been added to the cart\nClick on the cart to checkout...',
                                                    context);
                                              } else {
                                                _databaseService.removeCart(
                                                    user.uid, course.uid);
                                                add = Icons
                                                    .shopping_cart_outlined;
                                                showAlertDialog(
                                                    'Removed from Cart',
                                                    '\"' +
                                                        course.name +
                                                        '\"\nhas been removed from the cart\nBrowse for more...',
                                                    context);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  : Card(
                                      elevation: 5.0,
                                      color: Theme.of(context).primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '$progress%',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Text(
                            "Weeks: " + course.week.toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14.0,
                                fontFamily: 'Circular-Medium'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}

// class CourseCardList extends StatefulWidget {
//   @override
//   _CourseCardListState createState() => _CourseCardListState();
// }

// class _CourseCardListState extends State<CourseCardList> {
//   List<Course> courses = new List<Course>();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//         stream: Firestore.instance.collection('Courses').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Text(
//               'Loading, Please Wait',
//               style: TextStyle(color: Colors.white),
//             );
//           }
//           //print(snapshot.data.documents[0]['title'].toString());
//           snapshot.data.documents.forEach((document) {
//             // print(document['title']);
//             // print('Document ID:' + document.documentID);
//             courses.add(Course(
//               uid: document.documentID,
//               name: document['title'],
//             ));
//           });
//           return new ListView.builder(
//               itemCount: courses.length,
//               scrollDirection: Axis.vertical,
//               itemBuilder: (BuildContext ctxt, int index) =>
//                   CourseCard(courses: courses[index]));
//         },
//       ),
//     );
//   }
// }

class CourseCardList extends StatefulWidget {
  final List<Course> courses;
  bool showSideMenu = true;
  CourseCardList({this.courses, this.showSideMenu});
  @override
  _CourseCardListState createState() =>
      _CourseCardListState(courses: courses, showSideMenu: showSideMenu);
}

class _CourseCardListState extends State<CourseCardList> {
  List<Course> courses;
  bool showSideMenu = true;
  _CourseCardListState({this.courses, this.showSideMenu});
  @override
  Widget build(BuildContext context) {
    if (showSideMenu == null) {
      showSideMenu = true;
    }
    return Container(
      child: new ListView.builder(
          itemCount: courses.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext ctxt, int index) => CourseCard(
                courses: courses[index],
                showSideMenu: showSideMenu,
              )),
    );
  }
}

// Future<Widget> CourseCard(){

// }

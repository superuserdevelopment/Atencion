import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/courses.dart';
import 'package:e_learning/models/user.dart';
import 'package:e_learning/services/auth.dart';
import 'package:e_learning/services/database.dart';
import 'package:e_learning/widget_assets/courses_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class Landing_Fragment extends StatefulWidget {
  @override
  _Landing_FragmentState createState() => _Landing_FragmentState();
}

class _Landing_FragmentState extends State<Landing_Fragment> {
  int _currentIndex = 0;
  final DatabaseService _databaseService = DatabaseService();
  int itemsCart;
  //List<String> courseUids = new List<String>();
  List<String> categories = [
    'Finance',
    'Computers',
    'Data Science',
    'Psycology',
    'Instrumentation'
  ];
  @override
  void initState() {
    super.initState();
  }

  Widget categoriesBuildBody(BuildContext ctxt, int index) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Theme.of(context).accentColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              categories[index],
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    //getData();
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List wishlist = snapshot.data['cart'];
            itemsCart = wishlist.length;
          }
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 75.0,
                          ),

                          //Categories Carousel
                          SizedBox(
                            height: 47.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: new ListView.builder(
                                      itemCount: categories.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) =>
                                              categoriesBuildBody(ctxt, index)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                            child: Logo(),
                          ),
                          //Courses Carousel
                          Expanded(
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('Courses')
                                  .snapshots(),
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
                                  if (document['title'] != null &&
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
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      //Search bar and Cart icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                                child: buildFloatingSearchBar(context)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Stack(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () {
                                    //Write Code to go to cart
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                  iconSize: 25.0,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                Card(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: Text(
                                      itemsCart.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Widget buildFloatingSearchBar(BuildContext context) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  return FloatingSearchBar(
    hint: 'Start Learning Now...',
    textInputType: TextInputType.multiline,
    queryStyle: TextStyle(color: Colors.black),

    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 500),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    borderRadius: BorderRadius.circular(25.0),
    maxWidth: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
      print(query);
    },
    onSubmitted: (query) {
      //Code for submitting query
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Colors.black,
          elevation: 8.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: searchSuggestions(context, [
              'Data Structures with Python',
              'Technical Analysis',
              'Data Structures',
              'Algorithms'
            ]),
            // children: Colors.accents.map((color) {
            //   return Container(height: 30.0, color: color);
            // }).toList(),
          ),
        ),
      );
    },
  );
}

List<Widget> searchSuggestions(
  BuildContext context,
  List<String> items,
) {
  List<Widget> search = [];
  for (int i = 0; i < items.length; i++) {
    search.add(
      Container(
        width: 2000.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(items[i])),
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
  return search;
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SvgPicture.asset(
          'assets/vectors/line2.svg',
          semanticsLabel: 'Line',
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
}

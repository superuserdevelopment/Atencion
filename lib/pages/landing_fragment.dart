import 'package:e_learning/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Landing_Fragment extends StatefulWidget {
  @override
  _Landing_FragmentState createState() => _Landing_FragmentState();
}

class _Landing_FragmentState extends State<Landing_Fragment> {
  int _currentIndex = 0;
  List<String> categories = [
    'Finance',
    'Computers',
    'Data Science',
    'Psycology',
    'Instrumentation'
  ];

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
                  children: [
                    SizedBox(
                      height: 80.0,
                    ),
                    SizedBox(
                      height: 47.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: new ListView.builder(
                                itemCount: categories.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext ctxt, int index) =>
                                    categoriesBuildBody(ctxt, index)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                ),
                //Search bar and Cart icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(child: buildFloatingSearchBar(context)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          //Write Code to go to cart
                        },
                        iconSize: 25.0,
                        color: Theme.of(context).primaryColorLight,
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
            children: searchSuggestions(context, ['Hello', 'Bye', 'Tata']),
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

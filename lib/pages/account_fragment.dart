import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/user.dart';
import 'package:e_learning/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class AccountFragment extends StatefulWidget {
  @override
  _AccountFragmentState createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  int completed = 0;
  int pending = 0;
  User user = new User();
  final AuthenticationService _auth = new AuthenticationService();
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'Loading, Please Wait',
              style: TextStyle(color: Colors.white),
            );
          }
          //print(snapshot.data.documents[0]['title'].toString());
          String name = snapshot.data['name'] != null
              ? snapshot.data['name']
              : 'Error: Name not found';
          String email = snapshot.data['email'] != null
              ? snapshot.data['email']
              : 'Error: Name not found';
          completed = 0;
          pending = 0;
          Map<String, dynamic> progress = snapshot.data['progress'];
          if (progress.isNotEmpty) {
            progress.forEach((key, value) {
              if (value == 100) {
                completed++;
              } else {
                pending++;
              }
            });
          }
          print(completed.toString() + ' ' + pending.toString());
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Logo(),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 15.0),
                        child: Card(
                            elevation: 10.0,
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                                width: MediaQuery.of(context).size.width - 20,
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                    // fontFamily:
                                                    //     'Circular-Medium'
                                                  ),
                                                ),
                                                Text(
                                                  email,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily:
                                                          'Circular-Medium'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ))))),
                    Divider(
                      thickness: 5.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    UpdatesBar(
                      completed: completed,
                      pending: pending,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _auth.signOut();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      color: Theme.of(context).primaryColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Sign-out',
                          style: TextStyle(
                              fontSize: 24.0, fontFamily: 'Circular-Medium'),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }
}

class UpdatesBar extends StatefulWidget {
  int completed;
  int pending;
  UpdatesBar({this.completed, this.pending});
  @override
  _UpdatesBarState createState() =>
      _UpdatesBarState(completed: completed, pending: pending);
}

class _UpdatesBarState extends State<UpdatesBar> {
  int completed;
  int pending;
  _UpdatesBarState({this.completed, this.pending});
  Widget subCards(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Card(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10.0,
        child: Container(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$title',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 15.0,
                        //fontFamily: 'Calibre',
                      ),
                    ),
                    Text(
                      '$value',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 40.0,
                        fontFamily: 'Circular-Medium',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Completed: ' + pending.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        elevation: 10.0,
        child: Container(
          width: 2000.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Your Courses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        //fontFamily: 'Calibre',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: subCards(
                                  context, 'Completed', completed.toString())),
                          SizedBox(
                            width: 40.0,
                          ),
                          Expanded(
                              child: subCards(
                                  context, 'Pending', pending.toString())),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget Logo() {
  return Container(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'My Profile',
        style: TextStyle(
            fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      SvgPicture.asset(
        'assets/vectors/line2.svg',
        semanticsLabel: 'Line',
        width: 200.0,
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

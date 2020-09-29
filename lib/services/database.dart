import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('Users');
  //final CollectionReference notesCollection = Firestore.instance.collection('Notes');
  //final CollectionReference noteItemsCollection = Firestore.instance.collection('NoteItems');

  Future updateUserData(
    String name,
    String email,
  ) async {
    return await usersCollection.document(uid).setData({
      'name': name,
      'email': email,
      'enrolledCourses': [],
      'wishlistedCourses': [],
      'progress': {},
    });
  }
}

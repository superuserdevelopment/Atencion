import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/courses.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('Users');
  final CollectionReference coursesCollection =
      Firestore.instance.collection('Courses');
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
      'cart': [],
    });
  }

  Future<List<Course>> retrieveCourse() async {
    QuerySnapshot coursesQuery = await coursesCollection.getDocuments();
    List<Course> courses = new List<Course>();
    coursesQuery.documents.forEach((document) {
      courses.add(Course(
        uid: document.documentID,
        name: document['title'],
      ));
    });
    for (int i = 0; i < courses.length; i++) {
      courses[i].display();
    }
    return courses;
  }

  Future updateWishlist(String userUid, String courseUid) async {
    try {
      await usersCollection.document(userUid).updateData({
        'wishlistedCourses': FieldValue.arrayUnion([courseUid]),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future removeWishlist(String userUid, String courseUid) async {
    try {
      await usersCollection.document(userUid).updateData({
        'wishlistedCourses': FieldValue.arrayRemove([courseUid]),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future updateCart(String userUid, String courseUid) async {
    try {
      await usersCollection.document(userUid).updateData({
        'cart': FieldValue.arrayUnion([courseUid]),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future removeCart(String userUid, String courseUid) async {
    try {
      await usersCollection.document(userUid).updateData({
        'cart': FieldValue.arrayRemove([courseUid]),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future emptyCart(String userUid) async {
    try {
      await usersCollection.document(userUid).updateData({
        'cart': [],
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future enrollCourse(String userUid, String courseUid) async {
    try {
      await usersCollection.document(userUid).updateData({
        'enrolledCourses': FieldValue.arrayUnion([courseUid])
      });
      dynamic progress =
          await usersCollection.document(userUid).get().then((value) {
        print(value.data['progress']);
        return value.data['progress'];
      });
      if (progress.isNotEmpty) {
        progress[courseUid] = 0;
      } else {
        progress = new Map();
        progress[courseUid] = 0;
      }
      print(progress);
      await usersCollection.document(userUid).updateData({
        'progress': progress,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

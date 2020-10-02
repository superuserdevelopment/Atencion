class Course {
  String uid;
  String name;
  List<Week> weeks = [];
  String graphicUrl;
  int week;
  Course({this.uid, this.name, this.graphicUrl, this.week});
  void display() {
    print(uid);
    print(name);
  }
}

class Week {}

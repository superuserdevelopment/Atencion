class User {
  final String uid;
  List<String> enrolledCoursesIds = [];
  List<String> wishlistedCoursesIds = [];
  Map<String, int> progress = {}; // course uid : progress index

  User({this.uid});

  void addEnrolledCourse(String courseId) {
    enrolledCoursesIds.add(courseId);
    progress[courseId] = 0;
  }

  void removeEnrolledCourse(String courseId) {
    enrolledCoursesIds.remove(courseId);
    progress.remove(courseId);
  }

  void addWishlistedCourse(String courseId) {
    wishlistedCoursesIds.add(courseId);
  }

  void removeWishlistedCourse(String courseId) {
    wishlistedCoursesIds.remove(courseId);
  }

  void incProgress(String uid) {
    progress[uid]++;
  }

  void resetProgress(String uid) {
    progress[uid] = 0;
  }
}

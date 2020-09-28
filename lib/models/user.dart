class User {
  final String uid;
  List<String> recievedNoteIds = [];
  List<String> sentNoteIds = [];
  Map Friends = {}; // 'Friend's name : uid of Friend

  User({this.uid});
  void addUserNote(String noteId) {
    recievedNoteIds.add(noteId);
  }

  void removeUserNote(String noteId) {
    sentNoteIds.remove(noteId);
  }

  void addFriend(String name, String uid) {
    Friends[name] = uid;
  }

  void removeFriend(String name, String uid) {
    Friends.remove(uid);
  }
}

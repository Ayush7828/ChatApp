class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilpic;
  UserModel({this.uid, this.fullname, this.email, this.profilpic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    fullname = map['fullname'];
    email = map['email'];
    profilpic = map['profilpic'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'profilpic': profilpic,
    };
  }
}

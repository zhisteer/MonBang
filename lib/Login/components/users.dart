class Users {
  String? uid;
  String? email;
  String? name;
  Users({
    this.uid,
    this.email,
    this.name,
  });

  factory Users.fromMap(map) {
    return Users(
      email: map['email'],
      name: map['name'],
      uid: map['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}

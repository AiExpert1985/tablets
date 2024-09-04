import 'dart:convert';

class AppUser {
  final String uid;
  final String userName;
  final String email;
  final String imageUrl;
  final String privilage;
  AppUser({
    required this.uid,
    required this.userName,
    required this.email,
    required this.imageUrl,
    required this.privilage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'imageUrl': imageUrl,
      'privilage': privilage,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      privilage: map['privilage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));
}

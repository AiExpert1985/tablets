import 'dart:convert';

class ApplicationUser {
  final String uid;
  final String userName;
  final String email;
  final String imageUrl;
  final String privilage;
  ApplicationUser({
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

  factory ApplicationUser.fromMap(Map<String, dynamic> map) {
    return ApplicationUser(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      privilage: map['privilage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationUser.fromJson(String source) =>
      ApplicationUser.fromMap(json.decode(source));
}

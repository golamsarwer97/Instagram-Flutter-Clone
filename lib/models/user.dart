import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userName;
  final String? userEmail;
  final String? userId;
  final String? userBio;
  final String? photoUrl;
  final List? followers;
  final List? following;

  UserModel({
    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.userBio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'userEmail': userEmail,
        'userId': userId,
        'userBio': userBio,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      userName: snapshot['userName'],
      userEmail: snapshot['userEmail'],
      userId: snapshot['userId'],
      userBio: snapshot['userBio'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}

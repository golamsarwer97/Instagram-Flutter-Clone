// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String userId;
  final String userName;
  final String userProfileImage;
  final String postId;
  final String postDescription;
  final String postImageUrl;
  final DateTime postDatePublished;
  final likes;

  PostModel({
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.postId,
    required this.postDescription,
    required this.postImageUrl,
    required this.postDatePublished,
    this.likes,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userProfileImage': userProfileImage,
        'postId': postId,
        'postDescription': postDescription,
        'postImageUrl': postImageUrl,
        'postDatePublished': postDatePublished,
        'likes': likes,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      userId: snapshot['userId'],
      userName: snapshot['userName'],
      userProfileImage: snapshot['userProfileImage'],
      postId: snapshot['postId'],
      postDescription: snapshot['postDescription'],
      postImageUrl: snapshot['postImageUrl'],
      postDatePublished: snapshot['postDatePublished'],
      likes: snapshot['likes'],
    );
  }
}

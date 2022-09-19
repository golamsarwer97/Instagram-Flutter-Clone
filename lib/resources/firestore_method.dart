// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../resources/storage_method.dart';
import '../models/post.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    Uint8List file,
    String userId,
    String userName,
    String userProfileImage,
    // String postId,
    String postDescription,
    // String postImageUrl,
    // DateTime postDatePublished,
  ) async {
    String res = "Some error occurred";
    try {
      String postImageUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      PostModel post = PostModel(
        userId: userId,
        userName: userName,
        userProfileImage: userProfileImage,
        postId: postId,
        postDescription: postDescription,
        postImageUrl: postImageUrl,
        postDatePublished: DateTime.now(),
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String userId, List likes) async {
    try {
      if (likes.contains(userId)) {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postCmnt(
    String userId,
    String userName,
    String userProfileImage,
    String postId,
    String cmntText,
  ) async {
    String res = "Some error occurred";
    try {
      if (cmntText.isNotEmpty) {
        String cmntId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(cmntId)
            .set({
          'userId': userId,
          'userName': userName,
          'userProfileImage': userProfileImage,
          'postId': postId,
          'cmntId': cmntId,
          'cmntText': cmntText,
          'cmntDatePublished': DateTime.now(),
          'cmntLikes': [],
        });

        res = "Success";
      } else {
        res = 'Text is empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likeCmnt(
      String postId, String userId, String cmntId, List cmntLikes) async {
    try {
      if (cmntLikes.contains(userId)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(cmntId)
            .update({
          "cmntLikes": FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(cmntId)
            .update({
          "cmntLikes": FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('user').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

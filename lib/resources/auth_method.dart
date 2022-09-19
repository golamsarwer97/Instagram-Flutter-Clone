// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../resources/storage_method.dart';
import '../models/user.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    DocumentSnapshot snapshot =
        await _firestore.collection("user").doc(currentUser!.uid).get();

    return UserModel.fromSnap(snapshot);
  }

  Future<String> signin({
    required String userName,
    required String userEmail,
    required String userPassword,
    required String userBio,
    required Uint8List? userImageFile,
  }) async {
    String res = "Some error occurred";

    try {
      if (userEmail.isNotEmpty ||
          userName.isNotEmpty ||
          userPassword.isNotEmpty ||
          userBio.isNotEmpty ||
          userImageFile != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', userImageFile!, false);

        // Add user to our database

        UserModel user = UserModel(
          userName: userName,
          userEmail: userEmail,
          userId: cred.user!.uid,
          userBio: userBio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        _firestore.collection('user').doc(cred.user!.uid).set(user.toJson());

        res = "Success";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> logIn(String email, String password) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

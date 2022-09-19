// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/login_screen.dart';

import '../resources/firestore_method.dart';
import '../resources/auth_method.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/profile_screen/user_button.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int followersLength = 0;
  int followingLength = 0;
  int postLength = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      followersLength = userData['followers'].length;
      followingLength = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: widget.uid)
          .get();
      postLength = postSnap.docs.length;

      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['userName']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'] ??
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTR-E8-moq_eCC5VGLWGNWU8vsS2n5_Zw3tmD1qgPLG&s',
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postLength, 'Posts'),
                                    buildStateColumn(
                                      followersLength,
                                      'Followers',
                                    ),
                                    buildStateColumn(
                                      followingLength,
                                      'Following',
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? UserButton(
                                            text: 'Sign Out',
                                            function: () async {
                                              await AuthMethod().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(),
                                                ),
                                              );
                                            },
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            textColor: primaryColor,
                                          )
                                        : isFollowing
                                            ? UserButton(
                                                text: 'Unfollow',
                                                function: () async {
                                                  await FirestoreMethod()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['userId'],
                                                  );
                                                  setState(() {
                                                    isFollowing = false;
                                                    followersLength--;
                                                  });
                                                },
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                textColor: Colors.black,
                                              )
                                            : UserButton(
                                                text: 'Follow',
                                                function: () async {
                                                  await FirestoreMethod()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['userId'],
                                                  );
                                                  setState(() {
                                                    isFollowing = true;
                                                    followersLength++;
                                                  });
                                                },
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.grey,
                                                textColor: Colors.white,
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          userData['userName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          userData['userBio'],
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('userId', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: Colors.transparent,
                              ),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 5,
                              childAspectRatio: 1,
                            ),
                            itemCount: (snap.data as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot shot =
                                  (snap.data as dynamic).docs[index];
                              return Image(
                                image: NetworkImage(
                                  shot['postImageUrl'],
                                ),
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

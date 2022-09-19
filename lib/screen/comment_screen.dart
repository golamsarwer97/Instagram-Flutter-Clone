// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_method.dart';
import '../widgets/comment_screen/cmnt_card.dart';

class CommentScreen extends StatefulWidget {
  final cmntSnap;

  const CommentScreen({
    Key? key,
    this.cmntSnap,
  }) : super(key: key);
  static const routeName = '/comment-screen';

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _cmntTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _cmntTextController.dispose();
  }

  void postCmnt(
    String userId,
    String userName,
    String userProfileImage,
  ) async {
    try {
      String cmntPost = await FirestoreMethod().postCmnt(
        userId,
        userName,
        userProfileImage,
        widget.cmntSnap['postId'],
        _cmntTextController.text,
      );

      if (cmntPost == "Success") {
        print(cmntPost);
        _cmntTextController.clear();
      } else {
        print(cmntPost);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.cmntSnap['postId'])
            .collection('comments')
            .orderBy('cmntDatePublished', descending: true)
            .snapshots(),
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot,
        ) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(
              snapData: snapShot.data!.docs[index],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 18, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user!.photoUrl.toString()),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _cmntTextController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postCmnt(
                  user.userId.toString(),
                  user.userName.toString(),
                  user.photoUrl.toString(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 18,
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

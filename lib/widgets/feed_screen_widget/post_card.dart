// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, prefer_is_empty, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_method.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../screen/comment_screen.dart';
import '../../providers/user_provider.dart';
import '../../utils/global_variables.dart';
import '../feed_screen_widget/like_animation.dart';

class PostCard extends StatefulWidget {
  final snapData;

  const PostCard({Key? key, required this.snapData}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLikeAnimation = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: mobileBackgroundColor,
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          //HEADER SECTION
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(widget.snapData['userProfileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      widget.snapData["userName"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: width > webScreenSize
                                ? width * 0.4
                                : width * 0.3,
                            // vertical: width > webScreenSize ? 15 : 0,
                          ),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: ["Delete"]
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      await FirestoreMethod().deletePost(
                                          widget.snapData['postId']);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          //IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethod().likePost(
                widget.snapData['postId'],
                user!.userId.toString(),
                widget.snapData['likes'],
              );
              setState(() {
                _isLikeAnimation = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snapData['postImageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: _isLikeAnimation ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: _isLikeAnimation,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        _isLikeAnimation = false;
                      });
                    },
                    child: widget.snapData['likes'].contains(user!.userId)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 160,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 160,
                          ),
                  ),
                )
              ],
            ),
          ),

          //LIKE COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snapData['likes'].contains(user.userId),
                child: IconButton(
                  icon: widget.snapData['likes'].contains(user.userId)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    await FirestoreMethod().likePost(
                      widget.snapData['postId'],
                      user.userId.toString(),
                      widget.snapData['likes'],
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      cmntSnap: widget.snapData,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border_outlined),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // Description
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.snapData['likes'].length} likes',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snapData['userName'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' ${widget.snapData['postDescription']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.snapData['postId'])
                        .collection('comments')
                        .snapshots(),
                    builder: (
                      context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapShot,
                    ) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return Text(
                          '0 comment',
                          style: TextStyle(color: secondaryColor, fontSize: 16),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () {},
                          child: snapShot.data!.docs.length == 0
                              ? Text(
                                  '0 comment',
                                  style: TextStyle(
                                      color: secondaryColor, fontSize: 16),
                                )
                              : Text(
                                  'View all ${snapShot.data!.docs.length} comments',
                                  style: TextStyle(
                                      color: secondaryColor, fontSize: 16),
                                ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat.yMMMd().format(
                          widget.snapData['postDatePublished'].toDate()),
                      style: TextStyle(color: secondaryColor, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Padding(
//   padding: EdgeInsets.only(top: 8),
//   child: InkWell(
//     onTap: () {},
//     child: Text(
//       'View all 200 comments',
//       style: TextStyle(color: secondaryColor, fontSize: 16),
//     ),
//   ),
// ),

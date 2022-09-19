// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../resources/firestore_method.dart';
import '../../utils/colors.dart';
import '../feed_screen_widget/like_animation.dart';

class CommentCard extends StatefulWidget {
  final snapData;
  const CommentCard({Key? key, this.snapData}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snapData['userProfileImage']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          // text: widget.snapData['userName'], ${widget.snapData['postDescription']}
                          // DateFormat.yMMMd().format(widget.snapData['postDatePublished'].toDate()),
                          text: widget.snapData['userName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snapData['cmntText']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                          widget.snapData['cmntDatePublished'].toDate()),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeAnimation(
            isAnimating: widget.snapData['cmntLikes'].contains(user!.userId),
            child: IconButton(
              icon: widget.snapData['cmntLikes'].contains(user.userId)
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
              onPressed: () async {
                await FirestoreMethod().likeCmnt(
                  widget.snapData['postId'],
                  user.userId.toString(),
                  widget.snapData['cmntId'],
                  widget.snapData['cmntLikes'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

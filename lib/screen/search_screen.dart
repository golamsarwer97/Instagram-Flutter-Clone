// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screen/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = "/search-screen";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('user')
                  .where(
                    'userName',
                    isGreaterThanOrEqualTo: _searchController.text,
                    // isLessThanOrEqualTo: _searchController.text,
                  )
                  .get(),
              builder: (
                context,
                snapShot,
              ) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }

                if (!snapShot.hasData) {
                  return Center(
                    child: Text('No result'),
                  );
                }

                return ListView.builder(
                  itemCount: (snapShot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapShot.data! as dynamic).docs[index]
                                ['userId'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            (snapShot.data! as dynamic)
                                .docs[index]['photoUrl']
                                .toString(),
                          ),
                        ),
                        title: Text((snapShot.data! as dynamic).docs[index]
                            ['userName']),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (
                context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot,
              ) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }

                if (!snapShot.hasData) {
                  return Center(
                    child: Text('No result'),
                  );
                }

                return GridView.custom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      QuiltedGridTile(2, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      // QuiltedGridTile(2, 2),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => Image.network(
                      snapShot.data!.docs[index]['postImageUrl'],
                    ),
                    childCount: snapShot.data!.docs.length,
                  ),
                );
              },
            ),
    );
  }
}

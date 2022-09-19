// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

import './utils/colors.dart';
import './responsive/responsive_layout.dart';
import './responsive/mobile_screen_layout.dart';
import './responsive/web_screen_layout.dart';
import './screen/login_screen.dart';
import './screen/signin_screen.dart';
import './screen/feed_screen.dart';
import './screen/add_post_screen.dart';
import './screen/comment_screen.dart';
import './screen/search_screen.dart';
import './providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBx1DWWdYCt6a6CZ5Aw6hEr8NhkZ772ncI',
        appId: "1:958488488448:web:16e98b87996644f06a46e5",
        messagingSenderId: "958488488448",
        projectId: "instagram-clone-3d080",
        storageBucket: "instagram-clone-3d080.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: mobileBackgroundColor,
            centerTitle: false,
          ),
        ),
        debugShowCheckedModeBanner: false,
        // home: ResponsiveLayout(
        //   webScreenLayout: WebScreenLayout(),
        //   mobileScreenLayout: MobileScreenLayout(),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.active) {
              if (snapShot.hasData) {
                return ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapShot.hasError) {
                return Center(
                  child: Text(snapShot.error.toString()),
                );
              }
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
              );
            }

            return LoginScreen();
          },
        ),

        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          SignInScreen.routeName: (context) => SignInScreen(),
          FeedScreen.routeName: (context) => FeedScreen(),
          AddPostScreen.routeName: (context) => AddPostScreen(),
          CommentScreen.routeName: (context) => CommentScreen(),
          SearchScreen.routeName: (context) => SearchScreen(),
        },
      ),
    );
  }
}

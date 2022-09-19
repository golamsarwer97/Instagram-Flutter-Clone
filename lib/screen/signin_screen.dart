// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import './login_screen.dart';
import '../resources/auth_method.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const routeName = '/signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _userNameEditingController.dispose();
    _bioEditingController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    String auth = await AuthMethod().signin(
      userName: _userNameEditingController.text,
      userEmail: _emailEditingController.text,
      userPassword: _passwordEditingController.text,
      userBio: _bioEditingController.text,
      userImageFile: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if (auth != 'Success') {
      showSnackBar(context, auth);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogIn() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // reverse: true,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 64),
                Stack(
                  children: [
                    _image == null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-social-media-user-image-210115353.jpg',
                            ),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        // color: Colors.teal,
                        onPressed: selectImage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextInputField(
                  textEditingController: _userNameEditingController,
                  keyboardTextType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter Your Name',
                ),
                const SizedBox(height: 24),
                TextInputField(
                  textEditingController: _emailEditingController,
                  keyboardTextType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter Your Email',
                ),
                const SizedBox(height: 24),
                TextInputField(
                  textEditingController: _passwordEditingController,
                  keyboardTextType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter Your Password',
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                TextInputField(
                  textEditingController: _bioEditingController,
                  keyboardTextType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  hintText: 'Enter Your Bio',
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: signInUser,
                  child: _isLoading
                      ? Transform.scale(
                          scale: 1,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            // strokeWidth: 2,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          // height: 50,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: blueColor,
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Do have an account?"),
                    ),
                    GestureDetector(
                      onTap: navigateToLogIn,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Log In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

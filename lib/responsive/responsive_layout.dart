import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/global_variables.dart';
import '../providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = false;

  @override
  void initState() {
    // Provider.of<UserProvider>(context, listen: false).refreshUser();
    super.initState();
    adduser();
  }

  adduser() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    // UserProvider userProvider = Provider.of(context, listen: false);
    // await userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
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
        : LayoutBuilder(
            builder: (context, constraint) {
              if (constraint.maxWidth > webScreenSize) {
                return widget.webScreenLayout;
              }
              return widget.mobileScreenLayout;
            },
          );
  }
}

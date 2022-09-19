// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../utils/global_variables.dart';

class UserButton extends StatelessWidget {
  final String text;
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const UserButton({
    Key? key,
    required this.text,
    this.function,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width > webScreenSize ? 16 : 8,
      ),
      child: TextButton(
        onPressed: function,
        child: Container(
          height: 30,
          width: MediaQuery.of(context).size.width > webScreenSize
              ? MediaQuery.of(context).size.width / 1.5
              : 280,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

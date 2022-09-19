// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController textEditingController = TextEditingController();

  void totalDigit(int num) {
    String x = "";
    for (int i = 1; i <= num; i++) {
      x = x + i.toString();
    }
    print(x.length);
  }

  // void oddNum(int num){
  //   String x = "";
  //   for (int i = 1; i <= num; i++) {
  //     if(i / 2){
  //
  //     }
  //     x = x + i.toString();
  //   }
  //   print(x.length);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        controller: textEditingController,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          totalDigit(int.parse(value));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType keyboardTextType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final String hintText;

  const TextInputField(
      {Key? key,
      required this.textEditingController,
      required this.keyboardTextType,
      required this.textInputAction,
      this.isPassword = false,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      keyboardType: keyboardTextType,
      obscureText: isPassword,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(8),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
      ),
    );
  }
}

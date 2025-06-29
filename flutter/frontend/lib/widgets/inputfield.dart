import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? title;
  final bool obscureText;
  const InputField({super.key, this.title, this.obscureText = false});
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(8.0),
            right: Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

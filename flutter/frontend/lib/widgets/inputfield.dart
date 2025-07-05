import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String title;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const InputField(
   {
    super.key,
    this.title = "Default",
    this.obscureText = false,
    this.onChanged,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(color: Colors.black, fontSize: 12),
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

import 'package:flutter/material.dart';

class MyTextBoxes extends StatelessWidget {
  final IconData iconIn;
  final String name;
  final controller;
  final bool obscureText;
  const MyTextBoxes({super.key, required this.iconIn, required this.name, required this.controller, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(61, 131, 97,1.0),
              prefixIcon: Icon(iconIn),
              prefixIconColor: Color.fromRGBO(214, 205, 164, 1.0),
              labelText: name,
              labelStyle: TextStyle(
                color: Color.fromRGBO(238, 242, 230, 1.0),
              ),
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}
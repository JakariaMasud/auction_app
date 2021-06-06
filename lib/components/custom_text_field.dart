import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    @required this.width,
    @required this.controller,
    this.icon,
    @required this.labelText,
    @required this.textInputType,
    this.obscureText=false
  }) : super(key: key);

  final double width;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String labelText;
  final Icon icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width*0.9,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20.0,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.blue),
        ),
        child: icon==null? TextField(
          obscureText: obscureText,
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelText
          ),
        ) :TextField(
          obscureText: obscureText,
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            icon:icon,

          ),
        )
    );
  }
}
import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
  String text;
  double size;

  CustomText({@required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(fontSize: size == null ? 18.0 : size),
      ),
    );
  }
}
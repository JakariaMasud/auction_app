import 'package:flutter/material.dart';
class ProductFormField extends StatelessWidget {
  const ProductFormField({
    Key key,
    @required this.controller,
    @required this.labelText,
    @required this.inputType
  }) : super(key: key);

  final TextEditingController controller;
  final labelText;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
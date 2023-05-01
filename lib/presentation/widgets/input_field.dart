import 'package:flutter/material.dart';

class FormFieldInput extends StatelessWidget {
  FormFieldInput(this.field, this.isObscure, this.controller, {super.key, this.width, this.height});
  final String field;
  final bool isObscure;
  double? width;
  double? height;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 15),
      child: SizedBox(
        width: width ?? 300,
        height: height ?? 60,
        child: TextFormField(
          validator: ((value) {
            if (value == null || value.isEmpty) {
              return "Please enter the $field";
            }
            return null;
          }),
          maxLines: 7,
          obscureText: isObscure,
          controller: controller,
          decoration: InputDecoration(label: Text(field), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        ),
      ),
    );
  }
}

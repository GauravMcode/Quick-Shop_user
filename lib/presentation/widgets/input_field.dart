import 'package:flutter/material.dart';

class FormFieldInput extends StatelessWidget {
  const FormFieldInput(this.field, this.isObscure, this.controller, {super.key, this.width, this.height, this.inputType, this.padding, this.onChanged, this.validator});
  final String field;
  final bool isObscure;
  final double? width;
  final double? height;
  final TextInputType? inputType;
  final EdgeInsetsGeometry? padding;
  final TextEditingController controller;
  final onChanged;
  final validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 30, right: 15),
      child: SizedBox(
        width: width ?? 300,
        // height: height ?? 100,
        child: Card(
          elevation: 40,
          color: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: TextFormField(
              onChanged: onChanged,
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onSaved: (newValue) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              keyboardType: inputType,
              validator: validator ??
                  ((value) {
                    if (value == null || value.isEmpty) {
                      return 'enter "$field"';
                    }
                    return null;
                  }),
              obscureText: isObscure,
              controller: controller,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: Text(field),
                labelStyle: const TextStyle(color: Color(0xffffa502)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

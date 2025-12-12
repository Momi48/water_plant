import 'package:flutter/material.dart';

class UnderlineTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool required;
  final TextInputType inputType;

  const UnderlineTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.required = false,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return "This field is required";
          }
          return null;
        },
      ),
    );
  }
}

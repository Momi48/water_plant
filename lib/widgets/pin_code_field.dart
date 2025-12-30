import 'package:flutter/material.dart';

class PinCodeField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String val) onChanged;
  final String? Function(String? value) validator;
  const PinCodeField({super.key, 
  required this.controller,
  required this.onChanged,
  required this.validator, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
        color: Color(0xffD9D9D9), 
        
      ),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffD9D9D9), 
          counterText: "",
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none, 
          enabledBorder: InputBorder.none, 
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
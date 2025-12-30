import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool isPassword;
 final Widget? hint;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Color innerShadowColor;
  final double innerShadowHeight;

  const ReusableTextField({
    super.key,
    required this.label,
    this.suffixIcon,
    required this.controller,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.innerShadowColor = const Color(0xFF2E7D32),
    this.innerShadowHeight = 4.0,
     this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with padding
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Container with inner shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  // Background with gradient for inner shadow
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          innerShadowColor.withOpacity(0.2),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.05],
                      ),
                    ),
                  ),

                  // Text field
                  Padding(
                    padding: const EdgeInsets.all(1.0), // Creates border effect
                    child: TextFormField(
                      validator: validator,
                      controller: controller,
                      keyboardType: inputType,
                      obscureText: isPassword,
                      cursorColor: const Color(0xFF2E7D32),
                      decoration: InputDecoration(
                        hint: hint,
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: suffixIcon,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: innerShadowColor,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/pin_code_field.dart';
import 'package:water_plant/widgets/right_curve_painter.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final List<TextEditingController> pinCodeController = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Stack(
        children: [
          // --- CURVED SHAPE BACKGROUND ---
          Positioned(
            top: -screenHeight * 0.06,
            left: -screenWidth * 0.3,
            child: CustomPaint(
              size: Size(screenWidth * 1.5, screenHeight * 0.7),
              painter: RightCurvePainter(),
            ),
          ),

          // --- MAIN CONTENT ALWAYS ON TOP OF CURVE ---
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(35),
                margin: EdgeInsets.only(top: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),

                    // TITLE
                    Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 8),
                    Text(
                      "Please enter your PIN-code",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),

                    SizedBox(height: 30),

                    // PIN FIELDS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return PinCodeField(
                          controller: pinCodeController[index],
                          validator: (val) {
                            if (val!.isEmpty) return "Please Enter All Field";
                            return null;
                          },
                          onChanged: (val) {
                            if (index == 3) {
                              SqfliteServices().registerUserWithPin(
                                pinCode: pinCodeController[index].text,
                                context: context,
                              );
                            }
                            if (val.isNotEmpty && index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 50),
                    Text(
                      "Sign With Email And Password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in pinCodeController) {
      controller.dispose();
    }
    super.dispose();
  }
}

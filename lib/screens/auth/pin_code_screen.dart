import 'package:flutter/material.dart';
import 'package:water_plant/screens/home_screen.dart';
import 'package:water_plant/services/sqflite_services.dart';

import 'package:water_plant/widgets/pin_code_field.dart';
import 'package:water_plant/widgets/right_curve_painter.dart';
import 'package:water_plant/widgets/show_delete_dialog_box.dart';

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
    return Scaffold(
      body: Form(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(35),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Please enter your PIN-code",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 30),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(4, (index) {
                                    return PinCodeField(
                                      controller: pinCodeController[index],
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Please Enter All Field";
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        if (index == 3) {
                                          SqfliteServices().registerUserWithPin(
                                            pinCode:
                                                pinCodeController[index].text,
                                            context: context,
                                          );
                                        }
                                        if (val.isNotEmpty && index < 3) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),

                                const SizedBox(height: 25),

                                GestureDetector(
                                  onTap: () {
                                    showDeleteDialog(context,(){});
                                  },
                                  child: Text(
                                    "Sign With Email And Password?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

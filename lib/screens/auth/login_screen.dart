import 'package:flutter/material.dart';
import 'package:water_plant/screens/auth/register_screen.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/resuable_textfield.dart';
import 'package:water_plant/widgets/custom_button.dart';
import 'package:water_plant/widgets/right_curve_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Background curve
          Positioned(
            top: -screenHeight * 0.06,
            left: -screenWidth * 0.3,
            child: CustomPaint(
              size: Size(screenWidth * 1.5, screenHeight * 0.7),
              painter: RightCurvePainter(),
            ),
          ),

          // Header text
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    "Hello\nWelcome Back!",
                    textAlign: TextAlign.center, // Added text alignment
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),

          // Login form
          Positioned.fill(
            top: 150, // Fixed positioning
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                  ), // Reduced margin
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
                      Text(
                        'Login Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hello again! Sign in with your account to explore all the features, track your progress, and stay connected with everything you love.',
                        textAlign: TextAlign.center, // Added text alignment
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black54,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 20), // Increased spacing
                       ReusableTextField(
                        label: "Email",
                       hint: Text("Enter Email"),
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please Enter Email";
                          }
                          // Added email format validation
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(val)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),

                     
                       SizedBox(height: 15), // Consistent spacing
                      ReusableTextField(
                        label: "Password",
                        hint: Text("Enter Password"),
                        controller: passwordController,
                        isPassword: true,
                        suffixIcon: const Icon(Icons.lock),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please Enter Password";
                          }
                          if (val.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20), // Increased spacing
                      CustomButton(
                        text: "Login",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Added loading state or error handling
                            SqfliteServices().login(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                              context: context,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Create An Account",
                          style: TextStyle(
                            color: Colors
                                .blue, // Changed to blue for better visibility
                            fontSize: 16, // Slightly smaller
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

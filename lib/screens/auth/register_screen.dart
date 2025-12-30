import 'package:flutter/material.dart';
import 'package:water_plant/helper/show_snackbar.dart';
import 'package:water_plant/model/user_model.dart';
import 'package:water_plant/screens/auth/login_screen.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/resuable_textfield.dart';
import 'package:water_plant/widgets/custom_button.dart';
import 'package:water_plant/widgets/right_curve_painter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final businessController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();
  final pinCodeController = TextEditingController();

  bool isAgreement = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND HALF COLOR
         Positioned(
            top: -screenHeight * 0.06, 
            left: -screenWidth * 0.3,  
            child: CustomPaint(
              size: Size(
                screenWidth * 1.5,
                screenHeight * 0.7,
              ),
              painter: RightCurvePainter(),
            ),
          ),


          // TOP TEXTS (Register Now!, Create Account, Join us today)
          SafeArea(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Register Now!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // MAIN FORM CONTAINER
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),

              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.all(25),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CREATE ACCOUNT HEADER
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Join us today!",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),

                      const SizedBox(height: 25),

                      // FORM FIELDS
                      ReusableTextField(
                        label: "Name",
                        hint: Text("Enter Name"),
                        controller: nameController,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter name"
                            : null,
                      ),
                      ReusableTextField(
                        label: "Business",
                        hint: Text("Enter Business Name"),
                        controller: businessController,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter business"
                            : null,
                      ),
                      ReusableTextField(
                        label: "Email",
                        hint: Text("Enter Email"),
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter email";
                          }
                          if (!value.contains('@gmail.com')) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      ReusableTextField(
                        label: "Phone",
                        hint: Text("Enter Phone"),
                        controller: phoneController,
                        inputType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter phone"
                            : null,
                      ),
                      ReusableTextField(
                        label: "Location",
                        hint: Text("Enter Your Location"),
                        controller: locationController,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter location"
                            : null,
                      ),
                      ReusableTextField(
                        label: "Password",
                        hint: Text("Enter Password"),
                        controller: passwordController,
                        isPassword: true,
                        suffixIcon: Icon(Icons.lock),
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter password"
                            : null,
                      ),

                      // ReusableTextField(
                      //   label: "Pin Code",
                      //   controller: pinCodeController,
                      //   inputType: TextInputType.number,
                      //   validator: (value) => value == null || value.isEmpty
                      //       ? "Enter pin code"
                      //       : null,
                      // ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 10),
                            child: Text("Agreement"),
                          ),
                          Checkbox(
                            value: isAgreement,
                            onChanged: (value) {
                              setState(() => isAgreement = value ?? false);
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // REGISTER BUTTON
                      CustomButton(
                        text: "Register",
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          if (!isAgreement) {
                            showSnackBar(
                              message: "Please Accept the Agreement",
                              context: context,
                            );
                            return;
                          }

                          SqfliteServices().register(
                            userModel: UserModel(
                              password: passwordController.text,
                              name: nameController.text,
                              business: businessController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              location: locationController.text,
                            ),
                            context: context,
                          );
                        },
                      ),

                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Already Have an Account? Login",
                          style: TextStyle(
                            color: Colors.black,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    businessController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

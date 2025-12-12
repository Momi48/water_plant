import 'package:flutter/material.dart';
import '../widgets/resuable_textfield.dart';
import '../widgets/custom_button.dart';

const Color plantGreen = Color(0xFF2E7D32);

class LabourInfo extends StatefulWidget {
  const LabourInfo({super.key});

  @override
  State<LabourInfo> createState() => _LabourInfoState();
}

class _LabourInfoState extends State<LabourInfo> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();
  final addressController = TextEditingController();
  final dateOfJoiningController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Labour Info Form
return Padding(
  padding:  EdgeInsets.only(top: 60.0),
  child: SingleChildScrollView(
    padding:  EdgeInsets.symmetric(horizontal: 16),
    child: Form(
      key: _formKey,
      child: Container(
        padding:  EdgeInsets.all(25),
        margin:  EdgeInsets.symmetric(vertical: 20),
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
              'Labour Information',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please fill out the labour details to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black54,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 20),
  
            ReusableTextField(
              label: "Name",
              controller: nameController,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter name" : null,
            ),
  
            const SizedBox(height: 15),
            ReusableTextField(
              label: "CNIC",
              controller: cnicController,
              inputType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter CNIC" : null,
            ),
  
            const SizedBox(height: 15),
            ReusableTextField(
              label: "Mobile No",
              controller: mobile1Controller,
              inputType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter mobile number" : null,
            ),
  
            const SizedBox(height: 15),
            ReusableTextField(
              label: "Mobile No 2 (Optional)",
              controller: mobile2Controller,
              inputType: TextInputType.phone,
            ),
  
            const SizedBox(height: 15),
            ReusableTextField(
              label: "Address",
              controller: addressController,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter address" : null,
            ),
  
            const SizedBox(height: 15),
            ReusableTextField(
              label: "Date of Joining",
              controller: dateOfJoiningController,
              inputType: TextInputType.datetime,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter joining date" : null,
            ),
  
            const SizedBox(height: 20),
            CustomButton(
              text: "Submit",
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
  
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Labour info submitted successfully!"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  ),
);

    
  }
}

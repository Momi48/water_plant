import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';
import 'package:water_plant/model/labour_model.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/resuable_dropdown_textfield.dart';
import '../../widgets/resuable_textfield.dart';
import '../../widgets/custom_button.dart';

const Color plantGreen = Color(0xFF2E7D32);

class LabourInfo extends StatefulWidget {
  const LabourInfo({super.key});

  @override
  State<LabourInfo> createState() => _LabourInfoState();
}

class _LabourInfoState extends State<LabourInfo> {
  final _formKey = GlobalKey<FormState>();
  String? selectedJobType;
  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();
  final addressController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final commissionController = TextEditingController();
  final salaryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Labour Info Form
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: backgroundColorPlant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 60.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.symmetric(vertical: 20),
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
                      hint: Text("Enter Your Name"),
                      controller: nameController,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter name" : null,
                    ),

                    const SizedBox(height: 15),
                    ReusableTextField(
                      label: "CNIC",
                      hint: Text("Enter CNIC Number"),
                      controller: cnicController,
                      inputType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter CNIC" : null,
                    ),

                    const SizedBox(height: 15),
                    ReusableTextField(
                      label: "Mobile No",
                      hint: Text("Enter Phone No"),
                      controller: mobile1Controller,
                      inputType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter mobile number"
                          : null,
                    ),

                    const SizedBox(height: 15),
                    ReusableTextField(
                      label: "Mobile No 2 (Optional)",
                      hint: Text("Enter Phone No.2"),
                      controller: mobile2Controller,
                      inputType: TextInputType.phone,
                    ),

                    const SizedBox(height: 15),
                    ReusableTextField(
                      label: "Address",
                      hint: Text("Enter Your Address"),
                      controller: addressController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter address"
                          : null,
                    ),

                    const SizedBox(height: 15),
                    ReusableTextField(
                      label: "Date of Joining",
                      hint: Text("Enter DOT"),
                      controller: dateOfJoiningController,
                      inputType: TextInputType.datetime,
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter joining date"
                          : null,
                    ),
                    ReusableDropdown(
                      label: "Job Type",
                      value: selectedJobType,
                      items: ["salary", "commission"],
                      onChanged: (value) {
                        setState(() {
                          selectedJobType = value;
                        });
                      },
                    ),

                    // 👇 SHOW ONLY IF SALARY SELECTED
                    if (selectedJobType == "salary") ...[
                      const SizedBox(height: 15),
                      ReusableTextField(
                        label: "Salary",
                        hint: Text("Enter Your Salary"),
                        controller: salaryController,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter Salary"
                            : null,
                      ),
                    ],
                    if (selectedJobType == "commission") ...[
                      ReusableTextField(
                        label: "Commission %",
                        hint: Text("Enter Commission"),
                        controller: commissionController,
                        //  validator: (value) => value == null || value.isEmpty
                        //     ? "Enter Commission"
                        //     : null,
                      ),
                    ],
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Create",
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        SqfliteServices().labourInfo(
                          context: context,
                          labourModel: LabourModelData(
                            name: nameController.text,
                            cnic: cnicController.text,
                            mobile1: mobile1Controller.text,
                            mobile2: mobile2Controller.text,
                            dateOfJoining: dateOfJoiningController.text,
                            address: addressController.text,
                            jobType: selectedJobType,
                            salary:
                                (selectedJobType == 'salary' &&
                                    salaryController.text.isNotEmpty)
                                ? int.tryParse(salaryController.text)
                                : null,
                            commission:
                                selectedJobType == 'commission' &&
                                    commissionController.text.isNotEmpty
                                ? commissionController.text
                                : null,
                          ),
                        );
                        print('Selected $selectedJobType');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    cnicController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    addressController.dispose();
    dateOfJoiningController.dispose();
    commissionController.dispose();
    salaryController.dispose();
    super.dispose();
  }
}

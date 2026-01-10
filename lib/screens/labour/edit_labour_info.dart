import 'package:flutter/material.dart';
import '../../widgets/resuable_dropdown_textfield.dart';
import '../../widgets/resuable_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../services/sqflite_services.dart';
import '../../model/labour_model.dart';

class EditLabourInfo extends StatefulWidget {
  final LabourModelData? labour; // Nullable: if null → Add New

  const EditLabourInfo({super.key, this.labour});

  @override
  State<EditLabourInfo> createState() => _EditLabourInfoState();
}

class _EditLabourInfoState extends State<EditLabourInfo> {
  final _formKey = GlobalKey<FormState>();

  String? selectedJobType;

  final nameController = TextEditingController();
  final cnicController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();
  final addressController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final salaryController = TextEditingController();
  final commissionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill controllers if editing
    if (widget.labour != null) {
      nameController.text = widget.labour!.name ?? '';
      cnicController.text = widget.labour!.cnic ?? '';
      mobile1Controller.text = widget.labour!.mobile1 ?? '';
      mobile2Controller.text = widget.labour!.mobile2 ?? '';
      addressController.text = widget.labour!.address ?? '';
      dateOfJoiningController.text = widget.labour!.dateOfJoining ?? '';
      selectedJobType = widget.labour!.jobType;

      if (selectedJobType == "Salary") {
        salaryController.text = widget.labour!.salary != null
            ? widget.labour!.salary.toString()
            : '';
      } else if (selectedJobType == "Commission") {
        commissionController.text = widget.labour!.commission != null
            ? widget.labour!.commission.toString()
            : '';
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cnicController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    addressController.dispose();
    dateOfJoiningController.dispose();
    salaryController.dispose();
    commissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A50),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.labour == null ? 'Add Labour Info' : 'Edit Labour Info',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
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

                  // Name
                  ReusableTextField(
                    label: "Name",
                    hint: Text("Enter Your Name"),
                    controller: nameController,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 15),

                  // CNIC
                  ReusableTextField(
                    label: "CNIC",
                    hint: Text("Enter CNIC Number"),
                    controller: cnicController,
                    inputType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter CNIC" : null,
                  ),
                  const SizedBox(height: 15),

                  // Mobile 1
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

                  // Mobile 2
                  ReusableTextField(
                    label: "Mobile No 2 (Optional)",
                    hint: Text("Enter Phone No.2"),
                    controller: mobile2Controller,
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),

                  // Address
                  ReusableTextField(
                    label: "Address",
                    hint: Text("Enter Your Address"),
                    controller: addressController,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter address" : null,
                  ),
                  const SizedBox(height: 15),

                  // Date of Joining (Calendar Picker)
                  ReusableTextField(
                    label: "Date of Joining",
                    hint: Text("Select Date"),
                    controller: dateOfJoiningController,
                    inputType: TextInputType.none,
                    readonly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        dateOfJoiningController.text =
                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                            "${pickedDate.month.toString().padLeft(2, '0')}/"
                            "${pickedDate.year}";
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter joining date"
                        : null,
                  ),
                  const SizedBox(height: 15),

                  // Job Type Dropdown
                  ReusableDropdown(
                    label: "Job Type",
                    value: selectedJobType,
                    items: const ["salary", "commission"],
                    onChanged: (value) {
                      setState(() {
                        selectedJobType = value;
                      });
                    },
                  ),

                  // Salary field
                  if (selectedJobType == "salary") ...[
                    const SizedBox(height: 15),
                    ReusableTextField(
                      label: "Salary",
                      hint: const Text("Enter Salary"),
                      controller: salaryController,
                      inputType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter Salary"
                          : null,
                    ),
                  ],

                  // Commission field
                  const SizedBox(height: 20),

                  CustomButton(
                    text: widget.labour == null ? "Add Labour" : "Save Changes",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      if (widget.labour != null) {
                        // UPDATE existing record
                        await SqfliteServices().editLabourData(
                          labourId: widget.labour!.labourId!,
                          name: nameController.text,
                          cnic: cnicController.text,
                          mobile1: mobile1Controller.text,
                          mobile2: mobile2Controller.text,
                          address: addressController.text,
                          dateOfJoining: dateOfJoiningController.text,
                          jobType: selectedJobType,
                          salary: selectedJobType == "salary"
                                ? int.tryParse(salaryController.text)
                                : null,
                            commission: selectedJobType == "commission"
                                ? "0"
                                : null,
                          context: context,
                        );
                      } else {
                        // INSERT new record
                        await SqfliteServices().labourInfo(
                          labourModel: LabourModelData(
                            name: nameController.text,
                            cnic: cnicController.text,
                            mobile1: mobile1Controller.text,
                            mobile2: mobile2Controller.text,
                            address: addressController.text,
                            dateOfJoining: dateOfJoiningController.text,
                            jobType: selectedJobType,
                            salary: selectedJobType == "salary"
                                ? int.tryParse(salaryController.text)
                                : 0,
                            commission: selectedJobType == "commission"
                                ? "0"
                                : "0",
                          ),
                          context: context,
                        );
                        print("Salary input: ${salaryController.text}");
                        print(
                          "Commission string: ${selectedJobType == "commission" ? "0" : "0"}",
                        );
                        print("Selected job type: $selectedJobType");
                      }
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

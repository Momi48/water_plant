import 'package:flutter/material.dart';
import 'package:water_plant/model/consumer_model.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/consumer_day.dart';
import 'package:water_plant/widgets/custom_button.dart';
import 'package:water_plant/widgets/under_line_textfield.dart';

class ConsumerInfo extends StatefulWidget {
  const ConsumerInfo({super.key});

  @override
  State<ConsumerInfo> createState() => _ConsumerInfoState();
}

class _ConsumerInfoState extends State<ConsumerInfo> {
  final _formKey = GlobalKey<FormState>();
  ConsumerModel? consumerModel;
  final customerController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final addressController = TextEditingController();
  final advanceController = TextEditingController();
  final amountController = TextEditingController();
  final bottleController = TextEditingController();
  final balanceController = TextEditingController();
  final balanceBottleController = TextEditingController();
  final commissionController = TextEditingController();
  bool expanded = false;
  Map<String, bool> days = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A50),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // Header Title
            Text(
              "CONSUMER CREATE NEW",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            // White Card UI
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Custom Underline TextFields
                    UnderlineTextField(
                      hint: "Enter name.....",
                      controller: customerController,
                      required: true,
                    ),

                    UnderlineTextField(
                      hint: "Enter Phone 1.....",
                      controller: phone1Controller,
                      inputType: TextInputType.phone,
                      required: true,
                    ),

                    UnderlineTextField(
                      hint: "Enter Phone 2 (optional).....",
                      controller: phone2Controller,
                      inputType: TextInputType.phone,
                    ),

                    UnderlineTextField(
                      hint: "Address.....",
                      controller: addressController,
                      required: true,
                    ),

                    UnderlineTextField(
                      hint: "Advance (optional).....",
                      controller: advanceController,
                      inputType: TextInputType.number,
                    ),

                    UnderlineTextField(
                      hint: "Price...",
                      controller: amountController,
                      inputType: TextInputType.number,
                    ),

                    UnderlineTextField(
                      hint: "Bottle.....",
                      controller: bottleController,
                      inputType: TextInputType.number,
                    ),

                    const SizedBox(height: 10),

                    //Day Dropdown (Your ConsumerDay widget)
                    ConsumerDay(
                      days: days,
                      expanded: expanded,
                      onToggleExpand: () {
                        setState(() => expanded = !expanded);
                      },
                      onChange: (day, value) {
                        setState(() {
                          days[day] = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Create Button (Blue)
                    CustomButton(
                      text: "Create",
                      onPressed: () async {
                        await SqfliteServices().checkExistTable();
                        if (_formKey.currentState!.validate()) {
                          // Create ConsumerModel here
                          consumerModel = ConsumerModel(
                            name: customerController.text,
                            phone1: phone1Controller.text,
                            phone2: phone2Controller.text,
                            address: addressController.text,
                            advance: int.tryParse(advanceController.text) ?? 0,
                            price: int.tryParse(amountController.text) ?? 0,
                            bottles: int.tryParse(bottleController.text) ?? 0,
                            days: Days(
                              monday: days["Monday"],
                              tuesday: days["Tuesday"],
                              wednesday: days["Wednesday"],
                              thursday: days["Thursday"],
                              friday: days["Friday"],
                              saturday: days["Saturday"],
                              sunday: days["Sunday"],
                            ),
                          );

                          await SqfliteServices().consumerInfo(
                            consumerModel: consumerModel!,
                            context: context,
                          );

                          print('Consumer Info ${consumerModel!.toJson()}');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    customerController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    addressController.dispose();
    advanceController.dispose();
    amountController.dispose();
    bottleController.dispose();
    balanceController.dispose();
    balanceBottleController.dispose();
    commissionController.dispose();
    super.dispose();
  }
}

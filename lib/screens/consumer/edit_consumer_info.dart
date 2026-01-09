import 'package:flutter/material.dart';
import 'package:water_plant/model/consumer_model.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/consumer_day.dart';
import 'package:water_plant/widgets/custom_button.dart';
import 'package:water_plant/widgets/resuable_textfield.dart';

class EditConumserInfo extends StatefulWidget {
  final ConsumerModel? consumer;

  const EditConumserInfo({super.key, this.consumer});

  @override
  State<EditConumserInfo> createState() => _EditConumserInfoState();
}

class _EditConumserInfoState extends State<EditConumserInfo> {
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
  List<String> days = [];

  @override
void initState() {
  super.initState();
  if (widget.consumer != null) {
    final c = widget.consumer!;
    customerController.text = c.name ?? '';
    phone1Controller.text = c.phone1 ?? '';
    phone2Controller.text = c.phone2 ?? '';
    addressController.text = c.address ?? '';
    advanceController.text = c.advance?.toString() ?? '';
    amountController.text = c.price?.toString() ?? '';
    bottleController.text = c.bottles?.toString() ?? '';
    days = c.days ?? [];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A50),
      //drawer: AppDrawer(),
      appBar: AppBar(
      
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Go back to previous screen
        },
      ),
      title: Text(
        'Edit Consumer Info',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            // Header Title
            

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
                    ReusableTextField(
                      label: "Name",
                      controller: customerController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),

                    ReusableTextField(
                      label: "Phone 1",
                      controller: phone1Controller,
                      inputType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        return null;
                      },
                    ),

                    ReusableTextField(
                      label: "Phone 2 (Optional)",

                      controller: phone2Controller,
                      inputType: TextInputType.phone,
                    ),

                    ReusableTextField(
                      label: "Address",

                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address is required";
                        }
                        return null;
                      },
                    ),

                    ReusableTextField(
                      label: "Advance (Optional)",
                      hint: const Text("Enter Price (e.g 4 or 5 etc)"),
                      controller: advanceController,
                      inputType: TextInputType.number,
                    ),

                    ReusableTextField(
                      label: "Price",
                      hint: Text("Enter Price (e.g 25 or 80 etc)"),
                      controller: amountController,
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Price is required";
                        }
                        return null;
                      },
                    ),

                    ReusableTextField(
                      label: "Bottle",
                      hint: const Text("Bottle (eg 1,2 or 3)"),
                      controller: bottleController,
                      inputType: TextInputType.number,
                    ),

                    const SizedBox(height: 10),

                    //  Day Dropdown (Your ConsumerDay widget)
                    // ConsumerDay(
                    //   selectedDays: days,
                    //   expanded: true,
                    //   onToggleExpand: () {
                    //     setState(() {
                    //       expanded = !expanded;
                    //     });
                    //   },
                    //   onChange: (day, isSelected) {
                    //     setState(() {
                    //       if (isSelected) {
                    //         days.add(day);
                    //       } else {
                    //         days.remove(day);
                    //       }
                    //     });
                    //   },
                    // ),
                    ConsumerDay(
                      initialSelectedDays: [],
                      onChanged: (value) {
                        setState(() {});
                        days = value;
                        print('Value is $days');
                      },
                    ),
                    SizedBox(height: 20),

                    // Create Button (Blue)
                    CustomButton(
  text: "Save Changes",
  onPressed: () async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.consumer != null) {
      // UPDATE existing consumer
      await SqfliteServices().editConsumerData(
        consumerId: widget.consumer!.consumerId!,
        name: customerController.text,
        phone1: phone1Controller.text,
        phone2: phone2Controller.text,
        address: addressController.text,
        advance: int.tryParse(advanceController.text) ?? 0,
        price: int.tryParse(amountController.text) ?? 0,
        bottles: int.tryParse(bottleController.text) ?? 0,
        days: days,
        context: context,
      );

      Navigator.of(context).pop(true);
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

import 'package:flutter/material.dart';
import 'package:water_plant/model/counter_sale_model.dart';
import 'package:water_plant/services/sqflite_services.dart';
import 'package:water_plant/widgets/resuable_textfield.dart';


void showEditCounterSaleDialog(
  BuildContext context,
  VoidCallback onSaved, [
  CounterSaleModel? model,
]) async {
  final amountController = TextEditingController(
    text: model?.amount?.toString() ?? "",
  );
  final dateController = TextEditingController(text: model?.date ?? "");

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              //  Close button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 22),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model == null
                          ? "Counter Sale Create"
                          : "Edit Counter Sale",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Amount
                    ReusableTextField(
                      label: "Amount",
                      hint: const Text("Enter amount....."),
                      controller: amountController,
                    ),

                    const SizedBox(height: 16),

                    // Date
                    ReusableTextField(
                      label: "Date",
                      hint: const Text("Enter date....."),
                      controller: dateController,

                      readonly: true,
                      suffixIcon: InkWell(
                        onTap: () async{
                          
                            final DateTime now = DateTime.now();

                            DateTime initialDate = now;

                            if (dateController.text.isNotEmpty) {
                              try {
                                final parts = dateController.text.split('-');
                                initialDate = DateTime(
                                  int.parse(parts[0]),
                                  int.parse(parts[1]),
                                  int.parse(parts[2]),
                                );
                              } catch (_) {}
                            }

                            final DateTime? pickedDate = await  showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              dateController.text =
                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            }
                          
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () async {
                        final updatedModel = CounterSaleModel(
                          id: model?.id, // REQUIRED FOR UPDATE
                          amount: int.parse(amountController.text),
                          date: dateController.text,
                        );

                        if (model == null) {
                          //  INSERT
                          SqfliteServices().counterSaleInfo(
                            counterSaleModel: updatedModel,
                            context: context,
                          );
                        } else {
                          //  UPDATE
                          await SqfliteServices().updateCounterSale(
                            context,
                            updatedModel,
                          );
                        }

                        Navigator.pop(context);
                        onSaved();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        model == null ? "Save" : "Update",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

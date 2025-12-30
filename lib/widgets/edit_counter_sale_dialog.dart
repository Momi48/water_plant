import 'package:flutter/material.dart';
import 'package:water_plant/widgets/resuable_textfield.dart';

void showEditCounterSaleDialog(BuildContext context) {
  final amountController = TextEditingController();
  final dateController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Close Button (top-right)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  size: 22,
                ),
              ),
            ),

            // Dialog Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Counter Sale Create",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount field
                  ReusableTextField(
                    label: "Amount",
                    hint: const Text("Enter amount....."),
                    controller: amountController,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter Amount" : null,
                  ),
                  const SizedBox(height: 16),

                  // Date field
                  ReusableTextField(
                    label: "Date",
                    hint: const Text("Enter date....."),
                    controller: dateController,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter Date" : null,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  const SizedBox(height: 25),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      // Save logic here
                      final amount = amountController.text;
                      final date = dateController.text;
                      print("Saved: $amount, $date");

                      Navigator.pop(context);
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
                    child: const Text(
                      "Save",
                      style: TextStyle(
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
      );
    },
  );
}

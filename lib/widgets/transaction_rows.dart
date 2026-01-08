import 'package:flutter/material.dart';

class TransactionRows extends StatelessWidget {
  final int amount;
  final String date;
  final Color? amountColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionRows({
    super.key,
    required this.amount,
    required this.date,
    this.amountColor,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Amount
          Expanded(
            flex: 2,
            child: Text(
              amount.toString(),
              style: TextStyle(
                color: amountColor ?? Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Date
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

          // Actions
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child:  Icon(Icons.edit_square, size: 18),
                  ),
                   SizedBox(width: 10),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.delete, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

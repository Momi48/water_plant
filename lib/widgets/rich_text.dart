import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';

class RichTextLabel extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const RichTextLabel({
    super.key, 
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title\n",
            style:  TextStyle(
              color: titleColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
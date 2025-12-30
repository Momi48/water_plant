import 'package:flutter/material.dart';
import 'package:water_plant/helper/global_varaibles.dart';

class RichTextLabel extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final TextAlign? textAlign;
  final Color? titleColor;

  const RichTextLabel({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.titleColor,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: textAlign == TextAlign.right
          ? CrossAxisAlignment.end
          : textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,

          ),
        ),
        SizedBox(height: 2), // space between title and value
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

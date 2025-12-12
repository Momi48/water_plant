import 'package:flutter/material.dart';

class ConsumerDay extends StatelessWidget {
  final Map<String, bool> days; // state comes from parent
  final bool expanded; // dropdown open/close
  final VoidCallback onToggleExpand; // parent handles expand toggle
  final Function(String day, bool value) onChange; // parent updates day value

  const ConsumerDay({
    super.key,
    required this.days,
    required this.expanded,
    required this.onToggleExpand,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggleExpand,
          child: Row(
            children: [
              SizedBox(width: 45),
              Icon(Icons.calendar_today, color: Colors.grey[700], size: 22),
              SizedBox(width: 6),
              Text(
                "Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 22,
                color: Colors.black87,
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        if (expanded)
          Container(
            width: 300,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayRow(["Monday", "Tuesday"]),
                _buildDayRow(["Wednesday", "Thursday"]),
                _buildDayRow(["Friday", "Saturday", "Sunday"]),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDayRow(List<String> dayNames) {
    // Ensure the row has exactly 3 items
    List<String> items = List.from(dayNames);
    int remainder = items.length % 3;
    if (remainder != 0) {
      int placeholders = 3 - remainder;
      for (int i = 0; i < placeholders; i++) {
        items.add(''); // empty string as placeholder
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 12, // spacing between items
        runSpacing: 8,
        children: items.map((day) {
          if (day.isEmpty) {
            return SizedBox(
              width: 100, // approximate width of a _dayItem
            );
          } else {
            return _dayItem(day);
          }
        }).toList(),
      ),
    );
  }

  Widget _dayItem(String day) {
    bool isSelected = days[day] ?? false;

    return GestureDetector(
      onTap: () => onChange(day, !isSelected),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color: Colors.black87,
          ),
           SizedBox(width: 6),
          Text(
            day,
            style:  TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

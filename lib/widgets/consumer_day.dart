import 'package:flutter/material.dart';

class ConsumerDay extends StatefulWidget {
  final List<String>? initialSelectedDays;
  final ValueChanged<List<String>>? onChanged;
  final String title;

  const ConsumerDay({
    super.key,
    this.initialSelectedDays,
    this.onChanged,
    this.title = "Day",
  });

  @override
  State<ConsumerDay> createState() => _ConsumerDayState();
}

class _ConsumerDayState extends State<ConsumerDay> {
  bool _expanded = false;
  late List<String> _selectedDays;

  final List<String> _allDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialSelectedDays ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Row(
            children: [
              const SizedBox(width: 45),
              Icon(Icons.calendar_today, color: Colors.grey[700], size: 22),
              const SizedBox(width: 6),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 22,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Expanded chips
        if (_expanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allDays.map((day) {
                final isSelected = _selectedDays.contains(day);
                return ChoiceChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                      widget.onChanged?.call(_selectedDays);
                    });
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

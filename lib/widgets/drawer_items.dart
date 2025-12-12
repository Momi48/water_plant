import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;
  final Color activeColor;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.activeColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? activeColor : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? activeColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onTap(index);
        Navigator.pop(context); // closes drawer
      },
    );
  }
}

import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Settings({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sunColor = isDarkMode ? Colors.grey : Colors.amber;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_sunny, color: sunColor, size: 30),
            const SizedBox(width: 12),
            const Text('Dark Mode', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Switch(
              value: isDarkMode,
              onChanged: onThemeChanged,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RepeatDaysSelector extends StatefulWidget {
  final List<int> initialDays;
  final ValueChanged<List<int>> onChanged;

  const RepeatDaysSelector({
    super.key,
    this.initialDays = const [],
    required this.onChanged,
  });

  @override
  State<RepeatDaysSelector> createState() => _RepeatDaysSelectorState();
}

class _RepeatDaysSelectorState extends State<RepeatDaysSelector> {
  late List<int> _selectedDays;

  final List<String> _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  void initState() {
    super.initState();
    _selectedDays = [...widget.initialDays];
  }

  void _toggleDay(int weekday) {
    setState(() {
      if (_selectedDays.contains(weekday)) {
        _selectedDays.remove(weekday);
      } else {
        _selectedDays.add(weekday);
      }
    });
    widget.onChanged(_selectedDays..sort());
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final weekday = index + 1;
        final label = _dayLabels[index];
        final isSelected = _selectedDays.contains(weekday);
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => _toggleDay(weekday),
        );
      }),
    );
  }
  
}
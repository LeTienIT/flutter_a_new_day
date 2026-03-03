import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/tool.dart';
import '../mood_list/mood_list_controller.dart';

class MoodFilterBar extends ConsumerWidget {
  const MoodFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(moodYearProvider);
    final month = ref.watch(moodMonthProvider);
    final day = ref.watch(moodDayProvider);

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildItem(
              context,
              label: "Năm",
              value: year == -1 ? "📅" : year.toString(),
              onTap: () => _showYearPicker(context, ref),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildItem(
              context,
              label: "Tháng",
              value: month?.toString() ?? "🗓️",
              onTap: () => _showMonthPicker(context, ref),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildItem(
              context,
              label: "Ngày",
              value: day?.toString() ?? "☀️",
              onTap: () => _showDayPicker(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {required String label, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
  Widget _buildCupertinoPicker(BuildContext context, {required List<String> items, required int initialIndex, required ValueChanged<int> onSelected, required VoidCallback onDone,}) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            child: TextButton(
              onPressed: onDone,
              child: const Text("Đóng", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController:
              FixedExtentScrollController(initialItem: initialIndex),
              onSelectedItemChanged: onSelected,
              children: items
                  .map((e) => Center(
                  child: Text(e,
                      style: const TextStyle(fontSize: 18))))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showYearPicker(BuildContext context, WidgetRef ref) {
    final currentYear = DateTime.now().year;
    final years = [-1, ...List.generate(30, (i) => currentYear - i)];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        int selected = ref.read(moodYearProvider);
        final currentMonth = ref.read(moodMonthProvider);
        final currentDay = ref.read(moodDayProvider);

        if (currentMonth != null && currentDay != null) {
          final maxDay = getDaysInMonth(selected, currentMonth);

          if (currentDay > maxDay) {
            ref.read(moodDayProvider.notifier).state = null;
          }
        }

        return _buildCupertinoPicker(
          context,
          items: years.map((e) => e == -1 ? "Tất cả" : e.toString()).toList(),
          initialIndex: years.indexOf(selected),
          onSelected: (index){
            selected = years[index];
            ref.read(moodYearProvider.notifier).state = selected;
            if (selected == -1) {
              ref.read(moodMonthProvider.notifier).state = null;
              ref.read(moodDayProvider.notifier).state = null;
            }
          },
          onDone: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
  void _showMonthPicker(BuildContext context, WidgetRef ref) {
    final months = ["Tất cả", ...List.generate(12, (i) => "${i + 1}")];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        int selectedIndex = ref.read(moodMonthProvider) == null ? 0 : ref.read(moodMonthProvider)!;

        return _buildCupertinoPicker(
          context,
          items: months,
          initialIndex: selectedIndex,
          onSelected: (index){
            selectedIndex = index;
            final selectedMonth = selectedIndex == 0 ? null : selectedIndex;
            ref.read(moodMonthProvider.notifier).state = selectedMonth;
            final currentDay = ref.read(moodDayProvider);
            if (selectedMonth != null && currentDay != null) {
              final maxDay = getDaysInMonth(
                  ref.read(moodYearProvider), selectedMonth);

              if (currentDay > maxDay) {
                ref.read(moodDayProvider.notifier).state = null;
              }
            }

          },
          onDone: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
  void _showDayPicker(BuildContext context, WidgetRef ref) {
    final year = ref.read(moodYearProvider);
    final month = ref.read(moodMonthProvider);

    final maxDay = month == null ? 31 : getDaysInMonth(year, month);

    final days = ["Tất cả", ...List.generate(maxDay, (i) => "${i + 1}")];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        int selectedIndex = ref.read(moodDayProvider) == null ? 0 : ref.read(moodDayProvider)!;

        if (selectedIndex > maxDay) {
          selectedIndex = 0;
        }

        return _buildCupertinoPicker(
          context,
          items: days,
          initialIndex: selectedIndex,
          onSelected: (index){
            selectedIndex = index;
            ref.read(moodDayProvider.notifier).state = selectedIndex == 0 ? null : selectedIndex;
          },
          onDone: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
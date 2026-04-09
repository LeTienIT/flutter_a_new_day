import 'package:a_new_day/features/habit/widget/habit_status_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../menu/menu.dart';
import '../../provider/habit_history_controller.dart';

class HabitStatusListScreen extends ConsumerWidget {
  const HabitStatusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitHistoryProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Danh sách')),
        drawer: const Drawer(child: Menu()),
        body: state.when(
          data: (_) {
            return Column(
              children: const [
                Divider(height: 1,),
                SizedBox(height: 10,),
                _DateFilterBar(),
                _ListViewSection(),
              ],
            );
          },
          error: (err, _) => Center(child: Text("Lỗi: $err")),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _ListViewSection extends ConsumerWidget {
  const _ListViewSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(filteredHabitHistoryProvider);

    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, idx) {
          return HabitStatusItem(h: list[idx]);
        },
      ),
    );
  }
}

/// ================= FILTER BAR =================

class _DateFilterBar extends ConsumerWidget {
  const _DateFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(filterYearProvider);
    final month = ref.watch(filterMonthProvider);
    final day = ref.watch(filterDayProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _box("Năm", year?.toString() ?? "--", context),
          const SizedBox(width: 8),
          _box("Tháng", month?.toString() ?? "--", context),
          const SizedBox(width: 8),
          _box("Ngày", day?.toString() ?? "--", context),
        ],
      ),
    );
  }

  Widget _box(String title, String value, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _openPicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _openPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => const _DatePickerPopup(),
    );
  }
}

/// ================= PICKER =================

class _DatePickerPopup extends ConsumerStatefulWidget {
  const _DatePickerPopup();

  @override
  ConsumerState<_DatePickerPopup> createState() =>
      _DatePickerPopupState();
}

class _DatePickerPopupState extends ConsumerState<_DatePickerPopup> {
  late FixedExtentScrollController yearCtrl;
  late FixedExtentScrollController monthCtrl;
  late FixedExtentScrollController dayCtrl;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    final year = ref.read(filterYearProvider) ?? now.year;
    final month = ref.read(filterMonthProvider) ?? now.month;
    final day = ref.read(filterDayProvider) ?? now.day;

    yearCtrl = FixedExtentScrollController(initialItem: year - 2000);
    monthCtrl = FixedExtentScrollController(initialItem: month - 1);
    dayCtrl = FixedExtentScrollController(initialItem: day - 1);
  }

  @override
  void dispose() {
    yearCtrl.dispose();
    monthCtrl.dispose();
    dayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final year = ref.watch(filterYearProvider);
    final month = ref.watch(filterMonthProvider);

    final now = DateTime.now();

    final displayYear = year ?? now.year;
    final displayMonth = month ?? now.month;

    final daysInMonth =
        DateTime(displayYear, displayMonth + 1, 0).day;

    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: const Text("Reset"),
                onPressed: () {
                  ref.read(filterYearProvider.notifier).state = null;
                  ref.read(filterMonthProvider.notifier).state = null;
                  ref.read(filterDayProvider.notifier).state = null;

                  final now = DateTime.now();
                  yearCtrl.jumpToItem(now.year - 2000);
                  monthCtrl.jumpToItem(now.month - 1);
                  dayCtrl.jumpToItem(now.day - 1);
                },
              ),
              CupertinoButton(
                child: const Text("Đóng"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const Divider(),

          /// PICKERS
          Expanded(
            child: Row(
              children: [
                /// YEAR
                Expanded(
                  child: CupertinoPicker(
                    scrollController: yearCtrl,
                    itemExtent: 40,
                    onSelectedItemChanged: (i) {
                      ref.read(filterYearProvider.notifier).state =
                          2000 + i;
                    },
                    children: List.generate(
                      50,
                          (i) => Center(child: Text('${2000 + i}')),
                    ),
                  ),
                ),

                /// MONTH
                Expanded(
                  child: CupertinoPicker(
                    scrollController: monthCtrl,
                    itemExtent: 40,
                    onSelectedItemChanged: (i) {
                      final m = i + 1;
                      ref.read(filterMonthProvider.notifier).state = m;

                      _fixDay(displayYear, m);
                    },
                    children: List.generate(
                      12,
                          (i) => Center(child: Text('Th ${i + 1}')),
                    ),
                  ),
                ),

                /// DAY
                Expanded(
                  child: CupertinoPicker(
                    scrollController: dayCtrl,
                    itemExtent: 40,
                    onSelectedItemChanged: (i) {
                      ref.read(filterDayProvider.notifier).state =
                          i + 1;
                    },
                    children: List.generate(
                      daysInMonth,
                          (i) => Center(child: Text('${i + 1}')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _fixDay(int year, int month) {
    final currentDay = ref.read(filterDayProvider);
    if (currentDay == null) return;

    final maxDay = DateTime(year, month + 1, 0).day;

    if (currentDay > maxDay) {
      ref.read(filterDayProvider.notifier).state = maxDay;
      dayCtrl.jumpToItem(maxDay - 1);
    }
  }
}
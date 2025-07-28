import 'package:a_new_day/features/habit/widget/habit_status_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../menu/menu.dart';
import '../../provider/habit_history_controller.dart';

class HabitStatusListScreen extends ConsumerWidget{
  const HabitStatusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitHistoryProvider);
    final listFilter = ref.watch(filteredHabitHistoryProvider);
    final filterType = ref.watch(habitFilterTypeProvider);
    final filterDate = ref.watch(habitFilterDateProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách'),),
      drawer: Drawer(child: Menu(),),
      body: state.when(
          data: (list) => Column(
            children: [
              //Ui lọc
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  DropdownButton<HabitHistoryFilterType>(
                    value: filterType,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(habitFilterTypeProvider.notifier).state = value;
                      }
                      if(value == 'all'){
                        ref.read(habitFilterDateProvider.notifier).state = null;
                      }
                    },
                    items: HabitHistoryFilterType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: filterDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selected != null) {
                        ref.read(habitFilterDateProvider.notifier).state = selected;
                      }
                    },
                    icon: const Icon(Icons.date_range),
                    label: Text(filterDate != null
                        ? DateFormat('dd/MM/yyyy').format(filterDate)
                        : 'Chọn ngày'),
                  ),
                  if (filterDate != null)
                    IconButton(
                      onPressed: () {
                        ref.read(habitFilterDateProvider.notifier).state = null;
                      },
                      icon: const Icon(Icons.clear),
                      tooltip: "Xoá bộ lọc",
                    )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: listFilter.length,
                      itemBuilder: (_,idx){
                        final item = list[idx];
                        return HabitStatusItem(h: item);
                      }
                  )
              ),
            ],
          ),
          error: (err,_) => Center(child: Text("Lỗi: $err"),),
          loading: () => const Center(child: CircularProgressIndicator(),)),
    );
  }

}
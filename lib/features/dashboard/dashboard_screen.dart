import 'package:a_new_day/features/dashboard/dashboard_provider.dart';
import 'package:a_new_day/features/dashboard/widget/habit_barChart.dart';
import 'package:a_new_day/features/dashboard/widget/habit_double_barChart.dart';
import 'package:a_new_day/features/dashboard/widget/mood_lineChart.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget{
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final stateNotifier = ref.read(dashboardProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Tổng quan'),),
      drawer: Drawer(child: Menu(),),
      body: state.when(
          data: (stats) {
            final topUsed = stats.usageStats;
            final best = stats.completionRates;
            final doubleBarChart = stateNotifier.mergeUsageAndCompletion(topUsed, best).take(9).toList();
            final moodListPoint = stats.moodEnergyPoint.reversed.toList();
            final deleted = stats.deletedHabitTitles;
            final daily = stats.daySummaries;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text('Nhật ký tâm trạng', style: Theme.of(context).textTheme.titleMedium),
                  MoodLineChart(data: moodListPoint,),
                  const SizedBox(height: 16),
                  Text('Năng lượng mỗi ngày', style: Theme.of(context).textTheme.titleMedium),
                  HabitWeeklyBarChart(summaries: daily),
                  Text('(7 ngày gần nhất)', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 16),
                  Text('Top công việc', style: Theme.of(context).textTheme.titleMedium),
                  HabitDoubleBarChart(data: doubleBarChart,),
                  const SizedBox(height: 16),

                  if (deleted.isNotEmpty) ...[
                    Text('Các việc đã không còn thực hiện', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 8),
                    ...deleted.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Row(
                        children: [
                          Icon(Icons.close, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )).toList(),
                    const SizedBox(height: 18),
                  ]
                ],
              ),
            );
          },
          error: (error, _) => Center(child: Text('Error: $error'),),
          loading: () => const CircularProgressIndicator()
      )
    );
  }

}
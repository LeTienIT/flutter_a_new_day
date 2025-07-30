import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/dashboard.dart'; // để format ngày


class HabitWeeklyBarChart extends StatelessWidget {
  final List<HabitDaySummary> summaries;

  const HabitWeeklyBarChart({super.key, required this.summaries});

  @override
  Widget build(BuildContext context) {
    final recent = summaries.take(8).toList().reversed.toList();

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= recent.length) return const SizedBox();
                    final date = recent[index].date;
                    final label = DateFormat('E').format(date); // "Mon", "Tue",...
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(label, style: const TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: List.generate(recent.length, (i) {
              final percent = recent[i].percent;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: percent,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: percent >= 100
                        ? Colors.green
                        : (percent >= 50 ? Colors.orange : Colors.red),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  )
                ],
              );
            }),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
                right: BorderSide.none,
                top: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

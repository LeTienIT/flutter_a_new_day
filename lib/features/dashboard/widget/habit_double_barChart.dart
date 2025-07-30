import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../data/models/dashboard.dart';

class HabitDoubleBarChart extends StatelessWidget {
  final List<HabitDoubleStat> data;
  final _random = Random();
  final Map<String, Color> habitColorMap = {};
  final Set<Color> usedColors = {};
  HabitDoubleBarChart({super.key, required this.data}){
    for (final item in data) {
      habitColorMap[item.title] = generateUniqueColor(usedColors);
      usedColors.add(habitColorMap[item.title]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = data.map((e) => e.count.toDouble()).reduce(max);
    final maxY = maxCount * 1.2;
    return  Column(
      children: [
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) {
                        final percent = ((value / maxCount) * 100).round();
                        return Text('$percent%');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          final title = data[index].title;
                          final color = habitColorMap[title] ?? Colors.grey;
                          return SideTitleWidget(
                              meta: meta,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              )
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 50,
                    ),
                  ),
                  topTitles: AxisTitles()
              ),
              groupsSpace: 20,
              barGroups: data.asMap().entries.map((entry) {
                // print(entry.value.percent);
                final index = entry.key;
                final stat = entry.value;

                return BarChartGroupData(
                  x: index,
                  barsSpace: 1,
                  barRods: [
                    BarChartRodData(
                      toY: stat.count.toDouble(),
                      color: Colors.blue,
                      width: 15,
                      borderRadius: BorderRadius.zero,
                    ),
                    BarChartRodData(
                      toY: stat.percent * maxCount,
                      color: Colors.orange,
                      width: 15,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                );
              }).toList(),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
            ),
          ),
        ),
        SizedBox(height: 10,),
        _buildLegend()
      ],
    );
  }

  Color generateUniqueColor(Set<Color> existingColors) {
    while (true) {
      final color = Color.fromARGB(
        255,
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
      if (!existingColors.contains(color)) {
        return color;
      }
    }
  }

  Widget _buildLegend(){
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 4),
            Text('Số lần làm'),

            const SizedBox(width: 12),

            Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 4),
            Text('% Hoàn thành'),
          ]
        ),
        SizedBox(height: 5,),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: habitColorMap.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: entry.value,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(entry.key),
              ],
            );
          }).toList(),
        )
      ],
    );
  }
}